#!/usr/bin/env bash
# Risolve i riferimenti alle credenziali degli utenti di prova dichiarati in
# product/reference/test-environments.yaml — senza che il valore finisca mai
# in un file tracciato.
#
# Perché serve. Il registro degli utenti di prova è tracciato da git e
# contiene solo RIFERIMENTI (`password_ref: local:CHIAVE`, `env:NOME`,
# `keychain:servizio/account`, `op://vault/item/campo`). Le skill che
# navigano un ambiente (app-test, demo-capture, test-accounts) chiedono il
# valore a questo helper al momento del login, e solo allora. Vedi
# playbook, "Ambienti e utenti di prova".
#
# Uso:
#   test-credentials.sh init-local       crea .governance/test-credentials.local.env
#                                        (dal template, permessi 600) se non esiste
#   test-credentials.sh check <ref>      exit 0 = risolvibile, 1 = no, 2 = non
#                                        verificabile senza sbloccare il password
#                                        manager. Non stampa MAI il valore.
#   test-credentials.sh resolve <ref>    stampa il valore su stdout (serve per
#                                        digitarlo nel form di login). È l'unico
#                                        sottocomando che espone un segreto.
#   test-credentials.sh status           stato del registro su QUESTO clone: per
#                                        ogni utente se le credenziali si risolvono,
#                                        chiavi locali non usate. Mai valori.
#   test-credentials.sh status --hook    come sopra, ma solo un systemMessage JSON
#                                        quando c'è qualcosa da fare (SessionStart).
#
# Niente schema `cmd:` (comandi arbitrari): il registro è tracciato, un
# comando lì sarebbe codice eseguito su ogni clone. Solo bash + coreutils;
# `security` (macOS) e `op` (1Password CLI) solo se un riferimento li usa.
# No-op silenzioso sul canonico (manca .governance/config.yaml) per status.

set -uo pipefail

REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || true)"
[ -z "$REPO_ROOT" ] && exit 0
cd "$REPO_ROOT" || exit 0

REGISTRY="product/reference/test-environments.yaml"
LOCAL_FILE=".governance/test-credentials.local.env"
LOCAL_TEMPLATE="framework/schema/test-credentials.local.template.env"

die() { printf '%s\n' "$1" >&2; exit "${2:-1}"; }

# --- Risoluzione dei riferimenti ------------------------------------------

local_value() {
  # local_value <CHIAVE> — stampa il valore della riga CHIAVE=… del file locale
  local key="$1" line
  [ -f "$LOCAL_FILE" ] || return 1
  while IFS= read -r line || [ -n "$line" ]; do
    case "$line" in
      "$key="*) printf '%s' "${line#*=}"; return 0 ;;
    esac
  done < "$LOCAL_FILE"
  return 1
}

# resolve_ref <ref> <mode>: mode "value" stampa il valore, mode "check" no.
# Ritorna 0 risolvibile, 1 no, 2 non verificabile senza sblocco.
resolve_ref() {
  local ref="$1" mode="$2" key val svc acct
  case "$ref" in
    local:*)
      key="${ref#local:}"
      [[ "$key" =~ ^[A-Z0-9_]+$ ]] || return 1
      val="$(local_value "$key")" || return 1
      [ -n "$val" ] || return 1
      [ "$mode" = value ] && printf '%s\n' "$val"
      return 0 ;;
    env:*)
      key="${ref#env:}"
      [[ "$key" =~ ^[A-Za-z_][A-Za-z0-9_]*$ ]] || return 1
      val="$(printenv "$key" 2>/dev/null)" || return 1
      [ -n "$val" ] || return 1
      [ "$mode" = value ] && printf '%s\n' "$val"
      return 0 ;;
    keychain:*/*)
      command -v security >/dev/null 2>&1 || return 1
      svc="${ref#keychain:}"; acct="${svc#*/}"; svc="${svc%%/*}"
      if [ "$mode" = value ]; then
        security find-generic-password -s "$svc" -a "$acct" -w 2>/dev/null || return 1
      else
        # senza -w legge solo gli attributi: nessun prompt di sblocco
        security find-generic-password -s "$svc" -a "$acct" >/dev/null 2>&1 || return 1
      fi
      return 0 ;;
    op://*)
      command -v op >/dev/null 2>&1 || return 1
      if [ "$mode" = value ]; then
        op read "$ref" 2>/dev/null || return 1
        return 0
      fi
      return 2 ;;   # verificarlo richiederebbe lo sblocco del password manager
    *)
      return 1 ;;
  esac
}

# --- Lettura del registro (best-effort, stesso stile di check-connectors) --

# Emette una riga per utente: id|status|username_ref|password_ref|otp_ref
# (separatore non-whitespace: con IFS=tab i campi vuoti collasserebbero)
registry_accounts() {
  [ -f "$REGISTRY" ] || return 0
  awk -v q="'" '
    function val(s) {
      sub(/^[[:space:]]*(-[[:space:]]*)?[A-Za-z_]+:[[:space:]]*/, "", s)
      sub(/[[:space:]]+#.*$/, "", s)
      gsub("^[\"" q "]|[\"" q "]$", "", s)
      gsub(/[[:space:]]+$/, "", s)
      return s
    }
    function flush() { if (id != "") printf "%s|%s|%s|%s|%s\n", id, st, ur, pr, orf; id=st=ur=pr=orf="" }
    /^accounts:/ { inlist=1; next }
    inlist && /^[^[:space:]#-]/ { flush(); inlist=0 }
    !inlist { next }
    /^[[:space:]]*#/ { next }
    /^[[:space:]]*-[[:space:]]*id:/ { flush(); id=val($0); next }
    /^[[:space:]]+status:/        { st=val($0); next }
    /^[[:space:]]+username_ref:/  { ur=val($0); next }
    /^[[:space:]]+password_ref:/  { pr=val($0); next }
    /^[[:space:]]+otp_ref:/       { orf=val($0); next }
    END { flush() }
  ' "$REGISTRY"
}

# Chiavi local: citate dal registro (una per riga)
registry_local_keys() {
  [ -f "$REGISTRY" ] || return 0
  grep -oE 'local:[A-Z0-9_]+' "$REGISTRY" 2>/dev/null | sed 's/^local://' | sort -u
}

local_keys() {
  [ -f "$LOCAL_FILE" ] || return 0
  sed -nE 's/^([A-Z0-9_]+)=.*/\1/p' "$LOCAL_FILE" | sort -u
}

# --- Sottocomandi ----------------------------------------------------------

cmd_init_local() {
  if [ -f "$LOCAL_FILE" ]; then
    printf 'Esiste già: %s (non lo tocco).\n' "$LOCAL_FILE"
  else
    mkdir -p "$(dirname "$LOCAL_FILE")"
    if [ -f "$LOCAL_TEMPLATE" ]; then cp "$LOCAL_TEMPLATE" "$LOCAL_FILE"; else : > "$LOCAL_FILE"; fi
    printf 'Creato: %s\n' "$LOCAL_FILE"
  fi
  chmod 600 "$LOCAL_FILE"
  if ! git check-ignore -q "$LOCAL_FILE"; then
    printf 'ATTENZIONE: %s NON risulta escluso da git — non scriverci credenziali finché il .gitignore di root non lo copre.\n' "$LOCAL_FILE" >&2
    exit 1
  fi
}

# Calcola i contatori e, se richiesto, il dettaglio leggibile.
cmd_status() {
  local hook="${1:-}"
  [ -f ".governance/config.yaml" ] || exit 0   # canonico / istanza non inizializzata
  if [ ! -f "$REGISTRY" ]; then
    [ "$hook" = "--hook" ] && exit 0
    printf 'Nessun registro (%s): lancia la skill test-accounts per crearlo.\n' "$REGISTRY"
    exit 0
  fi

  local id st ur pr orf rc_p rc_u rc_o res
  local n_active=0 n_ready=0 n_unknown=0 n_missing=0 n_broken=0 n_wanted=0 n_wanted_now=0
  local detail="" missing_ids="" broken_ids="" wanted_now_ids=""

  while IFS='|' read -r id st ur pr orf; do
    [ -z "$id" ] && continue
    [ -z "$st" ] && st="active"
    [ "$st" = "retired" ] && continue
    rc_p=1; [ -n "$pr" ] && { resolve_ref "$pr" check; rc_p=$?; }
    rc_u=0; [ -n "$ur" ] && { resolve_ref "$ur" check; rc_u=$?; }
    rc_o=0; [ -n "$orf" ] && { resolve_ref "$orf" check; rc_o=$?; }
    if [ "$rc_p" -eq 0 ] && [ "$rc_u" -eq 0 ] && [ "$rc_o" -eq 0 ]; then res="pronte"
    elif [ "$rc_p" -eq 1 ] || [ "$rc_u" -eq 1 ] || [ "$rc_o" -eq 1 ]; then res="mancanti"
    else res="nel password manager (da sbloccare)"
    fi
    case "$st" in
      wanted)
        n_wanted=$((n_wanted+1))
        if [ "$res" != "mancanti" ]; then n_wanted_now=$((n_wanted_now+1)); wanted_now_ids="${wanted_now_ids}${id} "; fi ;;
      broken)
        n_broken=$((n_broken+1)); broken_ids="${broken_ids}${id} " ;;
      *)
        n_active=$((n_active+1))
        case "$res" in
          pronte) n_ready=$((n_ready+1)) ;;
          mancanti) n_missing=$((n_missing+1)); missing_ids="${missing_ids}${id} " ;;
          *) n_unknown=$((n_unknown+1)) ;;
        esac ;;
    esac
    detail="${detail}  ${id} [${st}] — credenziali ${res}"$'\n'
  done < <(registry_accounts)

  local orphan_keys
  orphan_keys="$(comm -23 <(local_keys) <(registry_local_keys) | tr '\n' ' ')"
  orphan_keys="${orphan_keys% }"

  local perm_warn=""
  if [ -f "$LOCAL_FILE" ]; then
    local mode
    mode="$(stat -c '%a' "$LOCAL_FILE" 2>/dev/null || stat -f '%Lp' "$LOCAL_FILE" 2>/dev/null || echo "")"
    [ -n "$mode" ] && [ "$mode" != "600" ] && perm_warn="$LOCAL_FILE ha permessi $mode (atteso 600: chmod 600 $LOCAL_FILE)"
    git check-ignore -q "$LOCAL_FILE" || perm_warn="${perm_warn:+$perm_warn; }$LOCAL_FILE NON è escluso da git"
  fi

  if [ "$hook" != "--hook" ]; then
    printf 'Utenti di prova (%s), su questo clone:\n' "$REGISTRY"
    [ -n "$detail" ] && printf '%s' "$detail" || printf '  (nessun utente registrato)\n'
    [ -n "$orphan_keys" ] && printf 'Chiavi nel file locale non citate da nessun utente: %s\n' "$orphan_keys"
    [ -n "$perm_warn" ] && printf 'ATTENZIONE: %s\n' "$perm_warn"
    exit 0
  fi

  # --hook: solo se c'è qualcosa da fare
  local parts=""
  [ "$n_wanted_now" -gt 0 ] && parts="${parts}${n_wanted_now} utenti richiesti (wanted) ora hanno credenziali (${wanted_now_ids% }) → test-accounts li attiva e da lì app-test sa usarli · "
  [ -n "$orphan_keys" ] && parts="${parts}credenziali nuove nel file locale non ancora registrate (${orphan_keys}) → test-accounts le collega a un utente · "
  [ "$n_missing" -gt 0 ] && parts="${parts}${n_missing} utenti senza credenziali su questo clone (${missing_ids% }) → chiedile all'owner o usa il password manager · "
  [ "$n_broken" -gt 0 ] && parts="${parts}${n_broken} utenti con login rotto (${broken_ids% }) → test-accounts per ripararli · "
  [ -n "$perm_warn" ] && parts="${parts}${perm_warn} · "
  [ -z "$parts" ] && exit 0

  local msg="🧪 Utenti di prova: ${parts%· }"
  msg="$(printf '%s' "$msg" | tr '\n' ' ' | sed 's/\\/\\\\/g; s/"/\\"/g')"
  printf '{"systemMessage": "%s"}\n' "$msg"
  exit 0
}

case "${1:-}" in
  init-local) cmd_init_local ;;
  check)
    [ -n "${2:-}" ] || die "uso: test-credentials.sh check <ref>" 64
    resolve_ref "$2" check; exit $? ;;
  resolve)
    [ -n "${2:-}" ] || die "uso: test-credentials.sh resolve <ref>" 64
    resolve_ref "$2" value || die "Riferimento non risolvibile su questo clone: $2" 1
    ;;
  status) cmd_status "${2:-}" ;;
  *) die "uso: test-credentials.sh init-local | check <ref> | resolve <ref> | status [--hook]" 64 ;;
esac
