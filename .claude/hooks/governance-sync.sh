#!/usr/bin/env bash
# Sincronizzazione automatica dei DATI di un'istanza col remote `origin`.
# NON è la sincronizzazione del METODO del framework: quella è il remote
# `upstream`, gestita da `sync-framework-updates` con revisione umana.
# Vedi playbook, sezione "Sincronizzazione dell'istanza (`origin`)".
#
# Uso:
#   governance-sync.sh pull
#   governance-sync.sh push "<messaggio di commit>" [path ...]
#
# Principi (non negoziabili, vedi playbook):
#   - Solo fast-forward. Mai merge/rebase/stash automatici.
#   - Non blocca mai: offline, origin irraggiungibile, branch senza
#     upstream -> avviso ed exit 0. Rete di sicurezza: hook SessionStart
#     (pull) e check-unpushed.sh (push) a fine sessione.
#   - Opera SOLO su un'istanza inizializzata (esiste .governance/config.yaml)
#     e SOLO se origin non è il repo canonico -> altrimenti no-op.
#   - Disattivabile da .governance/config.yaml: sync.auto_pull / sync.auto_push
#     (assenti = attivi).

set -uo pipefail

MODE="${1:-}"

REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || true)"
[ -z "$REPO_ROOT" ] && exit 0
cd "$REPO_ROOT" || exit 0

CONFIG=".governance/config.yaml"
[ -f "$CONFIG" ] || exit 0   # canonico o istanza non inizializzata -> no-op

git remote get-url origin >/dev/null 2>&1 || {
  echo "ℹ️  governance-sync: nessun remote 'origin', salto."
  exit 0
}

# --- Guardia: non toccare mai il repo canonico anche se per errore è 'origin' ---
CANONICAL_FILE="framework/canonical-remote.txt"
if [ -f "$CANONICAL_FILE" ]; then
  normalize() {
    printf '%s' "$1" \
      | sed -E 's#^git@github\.com:#https://github.com/#' \
      | sed -E 's#\.git/?$##' \
      | tr -d '[:space:]'
  }
  CANONICAL_URL="$(grep -vE '^\s*#' "$CANONICAL_FILE" | grep -vE '^\s*$' | head -n1)"
  ORIGIN_URL="$(git remote get-url origin 2>/dev/null || true)"
  if [ -n "$CANONICAL_URL" ] && [[ "$(normalize "$CANONICAL_URL")" != *PLACEHOLDER-ORG* ]]; then
    if [ "$(normalize "$ORIGIN_URL")" = "$(normalize "$CANONICAL_URL")" ]; then
      echo "ℹ️  governance-sync: 'origin' è il repo canonico, salto (nessuna sync dati sul canonico)."
      exit 0
    fi
  fi
fi

# toggle: disattivato solo se la chiave è esplicitamente 'false'
toggle_off() {
  grep -Eq "^[[:space:]]+$1:[[:space:]]*false([[:space:]]*#.*)?$" "$CONFIG" 2>/dev/null
}

has_upstream() {
  git rev-parse --abbrev-ref --symbolic-full-name '@{u}' >/dev/null 2>&1
}

case "$MODE" in
  pull)
    toggle_off auto_pull && exit 0
    if ! has_upstream; then
      echo "ℹ️  governance-sync: il branch corrente non traccia un remote, salto il pull."
      exit 0
    fi
    if ! git fetch --quiet origin 2>/dev/null; then
      echo "⚠️  governance-sync: fetch di 'origin' fallito (offline?). Procedo con lo stato locale."
      exit 0
    fi
    if git pull --ff-only --quiet 2>/dev/null; then
      exit 0
    fi
    AHEAD="$(git rev-list '@{u}..HEAD' --count 2>/dev/null || echo '?')"
    BEHIND="$(git rev-list 'HEAD..@{u}' --count 2>/dev/null || echo '?')"
    echo ""
    echo "⚠️  governance-sync: impossibile allineare 'origin' in fast-forward."
    echo "    Locale avanti di ${AHEAD} commit, indietro di ${BEHIND}."
    echo "    Tu e un'altra persona avete lavorato in parallelo. NESSUN merge automatico."
    echo "    Risolvi prima di continuare:  git pull --rebase origin  (poi  git push)"
    echo "    Vedi playbook, sezione Sincronizzazione dell'istanza -> Cosa fare quando vedi l'avviso."
    echo ""
    exit 0
    ;;
  push)
    shift || true
    MSG="${1:-}"
    if [ -z "${MSG}" ]; then
      echo "governance-sync push: manca il messaggio di commit, salto." >&2
      exit 0
    fi
    shift || true
    if [ "$#" -gt 0 ]; then
      git add -- "$@" 2>/dev/null || true
    else
      git add -- product/ context/ .governance/config.yaml 2>/dev/null || true
    fi
    if ! git diff --cached --quiet 2>/dev/null; then
      git commit --quiet -m "${MSG}" || true
    fi
    toggle_off auto_push && {
      echo "ℹ️  governance-sync: auto_push disattivato in config — commit locale, push manuale."
      exit 0
    }
    if ! has_upstream; then
      echo "ℹ️  governance-sync: branch senza upstream — commit locale, push manuale."
      exit 0
    fi
    if git push --quiet 2>/dev/null; then
      exit 0
    fi
    echo ""
    echo "⚠️  governance-sync: push su 'origin' fallito (offline, o il team ha pushato nel frattempo)."
    echo "    Il commit e' salvato in locale (${MSG}). Per sincronizzare:"
    echo "        git pull --rebase origin && git push"
    echo "    A fine sessione check-unpushed.sh te lo ricorderà."
    echo ""
    exit 0
    ;;
  *)
    echo "Uso: governance-sync.sh pull | push \"<messaggio>\" [path ...]" >&2
    exit 0
    ;;
esac
