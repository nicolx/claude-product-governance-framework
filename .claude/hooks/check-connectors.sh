#!/usr/bin/env bash
# Promemoria (non bloccante) a inizio sessione: quali connettori esterni
# programmatici la config dell'istanza dichiara.
#
# Perché serve. `.governance/config.yaml` può dichiarare connettori a
# sistemi esterni — `jira:` (tracker di esecuzione), `metrics:`
# (analytics per NSM/KPI) e voci in `connectors:` (fra cui le sorgenti di
# contesto: `connectors[].folders`, lette da context-watch/context-intake). Le skill
# che li usano ne verificano la
# raggiungibilità a inizio processo (playbook, "Connettori esterni:
# dichiarati, verificati a inizio processo, mai un fallback silenzioso"),
# ma un connettore MCP può essere non loggato / OAuth scaduto: meglio
# saperlo subito che scoprirlo a metà di un Backlog Refinement. Questo
# hook NON può verificare i tool MCP da bash — è solo un promemoria di
# controllare `/mcp`.
#
# Simmetrico a check-inbox.sh / check-pending-approvals.sh / check-unpushed.sh:
# un solo messaggio testuale, nessuna azione. Attivo anche in dry-run.
# No-op sul canonico / istanza non inizializzata (manca
# .governance/config.yaml) e se nessun connettore programmatico è dichiarato.

set -uo pipefail

REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || true)"
[ -z "$REPO_ROOT" ] && exit 0
cd "$REPO_ROOT" || exit 0

CONFIG=".governance/config.yaml"
[ -f "$CONFIG" ] || exit 0   # canonico o istanza non inizializzata -> no-op

# Estrae il valore scalare di una chiave annidata: block_key + field.
# Cerca "field:" indentato che compaia dopo la riga "block_key:".
nested_value() {
  # nested_value <block> <field>
  awk -v blk="$1:" -v fld="$2:" '
    $0 ~ "^"blk"[[:space:]]*$" { inblk=1; next }
    /^[^[:space:]#]/ { inblk=0 }
    inblk && $1 == fld {
      sub(/^[[:space:]]*[^:]+:[[:space:]]*/, "")
      sub(/[[:space:]]*#.*$/, "")
      gsub(/[[:space:]]+$/, "")
      gsub(/^["'\''"]|["'\''"]$/, "")
      print
      exit
    }
  ' "$CONFIG"
}

# Un'integrazione è "programmatica" se non è vuota e non è "manuale".
is_programmatic() {
  case "$1" in
    ""|manuale|manual) return 1 ;;
    *) return 0 ;;
  esac
}

DECLARED=""
REAUTH=""

add_connector() {
  # add_connector <blocco>
  local blk="$1" intg re
  intg="$(nested_value "$blk" integration)"
  is_programmatic "$intg" || return 0
  DECLARED="${DECLARED}${blk}: ${intg}; "
  re="$(nested_value "$blk" reauth)"
  [ -n "$re" ] && REAUTH="${REAUTH}${blk} → \`${re}\` · "
}

add_connector jira
add_connector metrics

# Connettori custom in `connectors:` — conta le voci (`- name:`) e, se ce
# ne sono, riporta i loro `reauth:` uno per riga (parsing best-effort).
CUSTOM_COUNT="$(awk '
  /^connectors:/ { inlist=1; next }
  inlist && /^[^[:space:]#]/ { inlist=0 }
  inlist && /^[[:space:]]*-[[:space:]]*name:/ { n++ }
  END { print n+0 }
' "$CONFIG")"
if [ "${CUSTOM_COUNT:-0}" -gt 0 ]; then
  DECLARED="${DECLARED}${CUSTOM_COUNT} in \`connectors\`"
  # Sorgenti di contesto: voci con `folders:` (cartelle -> `- link:`).
  FOLDER_COUNT="$(awk '
    /^connectors:/ { inlist=1; next }
    inlist && /^[^[:space:]#]/ { inlist=0 }
    inlist && /^[[:space:]]*-[[:space:]]*link:/ { n++ }
    END { print n+0 }
  ' "$CONFIG")"
  if [ "${FOLDER_COUNT:-0}" -gt 0 ]; then
    if [ "$FOLDER_COUNT" -eq 1 ]; then FW="cartella"; else FW="cartelle"; fi
    DECLARED="${DECLARED} (${FOLDER_COUNT} ${FW} di contesto — le controlla context-watch)"
  fi
  DECLARED="${DECLARED}; "
  CUSTOM_RE="$(awk '
    /^connectors:/ { inlist=1; next }
    inlist && /^[^[:space:]#]/ { inlist=0 }
    inlist && /^[[:space:]]*reauth:[[:space:]]*[^[:space:]#]/ {
      v=$0; sub(/^[[:space:]]*reauth:[[:space:]]*/, "", v);
      sub(/[[:space:]]*#.*$/, "", v); gsub(/^["'\''"]|["'\''"]$/, "", v);
      if (v != "") printf "connectors → `%s` · ", v
    }
  ' "$CONFIG")"
  [ -n "$CUSTOM_RE" ] && REAUTH="${REAUTH}${CUSTOM_RE}"
fi

[ -z "$DECLARED" ] && exit 0

DECLARED="${DECLARED%; }"

MSG="⚙ La config dichiara connettori esterni ($DECLARED). Le skill che li usano li verificano a inizio processo; dichiarato ma irraggiungibile non è un fallback silenzioso (playbook, sezione Connettori esterni)."
if [ -n "$REAUTH" ]; then
  MSG="${MSG} Se scaduti (alcuni login OAuth scadono a ogni sessione), rimettili su: ${REAUTH%· }"
else
  MSG="${MSG} Verifica che siano connessi prima delle skill che li usano."
fi

# JSON-escape minimale (\ e "). Il messaggio è costruito su un'unica riga
# (separatori " · "), i valori di reauth vengono dal config: nessuna
# newline attesa, ma \ e " vanno comunque neutralizzati.
esc_json() {
  printf '%s' "$1" | tr '\n' ' ' | sed 's/\\/\\\\/g; s/"/\\"/g'
}

printf '{"systemMessage": "%s"}\n' "$(esc_json "$MSG")"
exit 0
