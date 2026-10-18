#!/usr/bin/env bash
# Sincronizzazione automatica dei DATI di un'istanza col remote `origin`.
# NON è la sincronizzazione del METODO del framework: quella è il remote
# `upstream`, gestita da `sync-framework-updates` con revisione umana.
# Vedi playbook, sezione "Sincronizzazione dell'istanza (`origin`)".
#
# Uso:
#   governance-sync.sh pull
#   governance-sync.sh push "<messaggio di commit>" [path ...]
#   governance-sync.sh apps
#
# `apps` porta ogni submodule sotto apps/ all'ultimo commit del suo branch
# remoto (fetch + checkout detached), così una diagnosi legge il codice
# corrente e non quello fermo al puntatore registrato. Non committa il
# puntatore aggiornato (apps/ è scritta solo da init-governance-project),
# salta i submodule con modifiche locali, e stampa per ciascuno il commit
# su cui la skill sta leggendo.
#
# Principi (non negoziabili, vedi playbook):
#   - Solo fast-forward. Mai merge/rebase/stash automatici.
#   - Non blocca mai: offline, origin irraggiungibile, branch senza
#     upstream -> avviso ed exit 0. Rete di sicurezza: hook SessionStart
#     (pull) e check-unpushed.sh (push) a fine sessione.
#   - Opera SOLO su un'istanza inizializzata (esiste .governance/config.yaml)
#     e SOLO se origin non è il repo canonico -> altrimenti no-op.
#   - Disattivabile da .governance/config.yaml: sync.auto_pull / sync.auto_push
#     / sync.apps_pull (assenti = attivi).

set -uo pipefail

MODE="${1:-}"

REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || true)"
[ -z "$REPO_ROOT" ] && exit 0
cd "$REPO_ROOT" || exit 0

CONFIG=".governance/config.yaml"
[ -f "$CONFIG" ] || exit 0   # canonico o istanza non inizializzata -> no-op

# `apps` lavora sui remote dei submodule, non su quello dell'istanza:
# le guardie su `origin` sotto valgono solo per pull/push dei dati.
[ "$MODE" = "apps" ] || git remote get-url origin >/dev/null 2>&1 || {
  echo "ℹ️  governance-sync: nessun remote 'origin', salto."
  exit 0
}

# --- Guardia: non toccare mai il repo canonico anche se per errore è 'origin' ---
CANONICAL_FILE="framework/canonical-remote.txt"
if [ "$MODE" != "apps" ] && [ -f "$CANONICAL_FILE" ]; then
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

# Modalità dry-run (simulazione): rete di sicurezza per cui il `push`
# non scrive mai verso origin. Attiva se la env GOVERNANCE_DRY_RUN è
# valorizzata (diversa da 0/false/no), o se .governance/config.yaml ha
# una chiave top-level `dry_run: true`. Vedi playbook, "Modalità dry-run".
dry_run_active() {
  case "${GOVERNANCE_DRY_RUN:-}" in
    ""|0|false|no|NO|False) : ;;
    *) return 0 ;;
  esac
  grep -Eq "^[[:space:]]*dry_run:[[:space:]]*true([[:space:]]*#.*)?$" "$CONFIG" 2>/dev/null
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
    if dry_run_active; then
      echo ""
      echo "🔍 governance-sync: DRY-RUN attivo — nessun commit, nessun push."
      echo "    Avrei committato:  ${*:-product/ context/ .governance/config.yaml}"
      echo "    Messaggio:         ${MSG}"
      echo ""
      exit 0
    fi
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
  apps)
    toggle_off apps_pull && exit 0
    [ -f .gitmodules ] || {
      echo "ℹ️  governance-sync apps: nessun submodule collegato, salto."
      exit 0
    }
    # mai un prompt di credenziali: un repo non accessibile è un avviso, non un blocco
    export GIT_TERMINAL_PROMPT=0
    while read -r KEY SUB_PATH <&3; do
      case "$SUB_PATH" in apps/*) : ;; *) continue ;; esac
      NAME="${KEY#submodule.}"; NAME="${NAME%.path}"
      if [ ! -e "$SUB_PATH/.git" ]; then
        if ! git submodule update --init --quiet -- "$SUB_PATH" 2>/dev/null; then
          echo "⚠️  $SUB_PATH: inizializzazione fallita (accesso al repo?). Non leggibile."
          continue
        fi
      fi
      if [ -n "$(git -C "$SUB_PATH" status --porcelain --untracked-files=no 2>/dev/null)" ]; then
        echo "⚠️  $SUB_PATH: modifiche locali, NON aggiornato — leggo $(git -C "$SUB_PATH" rev-parse --short HEAD 2>/dev/null) (stato locale)."
        continue
      fi
      OLD="$(git -C "$SUB_PATH" rev-parse --short HEAD 2>/dev/null || echo '?')"
      if ! git -C "$SUB_PATH" fetch --quiet origin 2>/dev/null; then
        echo "⚠️  $SUB_PATH: fetch fallito (offline?) — leggo $OLD, potrebbe non essere aggiornato."
        continue
      fi
      BRANCH="$(git config -f .gitmodules --get "submodule.$NAME.branch" 2>/dev/null || true)"
      if [ -z "$BRANCH" ]; then
        BRANCH="$(git -C "$SUB_PATH" ls-remote --symref origin HEAD 2>/dev/null \
          | sed -n 's#^ref: refs/heads/\([^[:space:]]*\)[[:space:]]*HEAD$#\1#p')"
      fi
      if [ -z "$BRANCH" ] || ! git -C "$SUB_PATH" rev-parse --verify --quiet "origin/$BRANCH" >/dev/null; then
        echo "⚠️  $SUB_PATH: branch remoto non determinabile — leggo $OLD."
        continue
      fi
      if ! git -C "$SUB_PATH" checkout --quiet --detach "origin/$BRANCH" 2>/dev/null; then
        echo "⚠️  $SUB_PATH: checkout di origin/$BRANCH fallito — leggo $OLD."
        continue
      fi
      NEW="$(git -C "$SUB_PATH" rev-parse --short HEAD)"
      if [ "$OLD" = "$NEW" ]; then
        echo "✅ $SUB_PATH: già allineato a origin/$BRANCH @ $NEW."
      else
        echo "✅ $SUB_PATH: aggiornato a origin/$BRANCH @ $NEW (era $OLD)."
      fi
    done 3< <(git config -f .gitmodules --get-regexp '^submodule\..*\.path$' 2>/dev/null)
    exit 0
    ;;
  *)
    echo "Uso: governance-sync.sh pull | push \"<messaggio>\" [path ...] | apps" >&2
    exit 0
    ;;
esac
