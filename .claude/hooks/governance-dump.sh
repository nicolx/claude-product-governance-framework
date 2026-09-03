#!/usr/bin/env bash
# Dump in UN SOLO colpo dello stato di un'istanza rilevante per una
# cerimonia o una vista — così una skill lo legge con una tool call invece
# di fare glob + leggi-ogni-file-N-volte.
#
# Perché serve. La sweep di apertura del Backlog Refinement invocava 6
# sotto-skill, ognuna con pull + glob di TUTTE le product/ideas/*/idea.yaml
# + scritture + push: le stesse idee lette 3-4 volte, 5-6 commit. La
# cerimonia blocca il tempo di molte persone in riunione — la sweep
# dev'essere calcolo, non attesa di I/O. Vedi playbook, "Product Backlog
# Refinement".
#
# Uso:
#   governance-dump.sh sweep         # tutto il quadro per il Backlog Refinement (default)
#   governance-dump.sh backlog       # idee + coda di approvazione (per backlog-list)
#   governance-dump.sh ideas [--all] # le idea.yaml (attive; --all include declined/aborted)
#   governance-dump.sh measurements  # product/prds/*/measurement*.yaml
#   governance-dump.sh iterations    # gli ultimi due product/roadmap/iterations/*.yaml
#   governance-dump.sh pending       # contenuto di product/approvals/pending/*.yaml
#   governance-dump.sh reference     # product/reference/*.yaml
#
# SOLA LETTURA: non scrive niente, non fa commit, non tocca git. Stampa su
# stdout. No-op (exit 0, nessun output) se non c'è una cartella product/
# (repo canonico, o istanza non ancora scaffoldata).
#
# Bash + coreutils + git + sed. Nessun'altra dipendenza (vincolo CLAUDE.md).

set -uo pipefail

REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || true)"
[ -z "$REPO_ROOT" ] && exit 0
cd "$REPO_ROOT" || exit 0

[ -d "product" ] || exit 0   # canonico / istanza non scaffoldata -> no-op silenzioso

MODE="${1:-sweep}"
INCLUDE_ALL=0
[ "${2:-}" = "--all" ] && INCLUDE_ALL=1

emit_file() {
  # emit_file <path>
  local f="$1"
  [ -f "$f" ] || return 0
  printf '\n━━━ %s ━━━\n' "$f"
  cat -- "$f"
  printf '\n'
}

emit_glob() {
  # emit_glob <dir> <pattern>  — silenzioso se non matcha nulla
  local dir="$1" pat="$2" f
  [ -d "$dir" ] || return 0
  find "$dir" -type f -name "$pat" 2>/dev/null | sort | while IFS= read -r f; do
    emit_file "$f"
  done
}

idea_status() {
  # prima riga "status: <valore>" (scalare) di una idea.yaml
  sed -n 's/^status:[[:space:]]*"\{0,1\}\([a-z_]*\).*/\1/p' "$1" 2>/dev/null | head -n1
}

emit_ideas() {
  # emit_ideas — tutte le idea.yaml; salta declined/aborted salvo INCLUDE_ALL
  local d st
  [ -d "product/ideas" ] || return 0
  find product/ideas -mindepth 2 -maxdepth 2 -name idea.yaml 2>/dev/null | sort | while IFS= read -r d; do
    if [ "$INCLUDE_ALL" -eq 0 ]; then
      st="$(idea_status "$d")"
      case "$st" in
        declined|aborted) continue ;;
      esac
    fi
    emit_file "$d"
  done
}

emit_iterations() {
  # gli ultimi due file per settimana ISO (il piano corrente + il based_on)
  local files
  [ -d "product/roadmap/iterations" ] || return 0
  files="$(find product/roadmap/iterations -maxdepth 1 -type f -name '*.yaml' 2>/dev/null | sort | tail -n 2)"
  printf '%s\n' "$files" | while IFS= read -r f; do
    [ -n "$f" ] && emit_file "$f"
  done
}

emit_pending() {
  [ -d "product/approvals/pending" ] || return 0
  find product/approvals/pending -maxdepth 1 -type f -name '*.yaml' ! -name '.gitkeep' 2>/dev/null \
    | sort | while IFS= read -r f; do emit_file "$f"; done
}

emit_reference() {
  emit_file "product/reference/nsm-tracking.yaml"
  emit_file "product/reference/annual-target.yaml"
  emit_file "product/reference/product-lines.yaml"
  emit_file "product/reference/friction-log.yaml"
}

footer() {
  local ideas active done_ prds_m pend iters
  ideas="$(find product/ideas -mindepth 2 -maxdepth 2 -name idea.yaml 2>/dev/null | wc -l | tr -d ' ')"
  active="$(find product/ideas -mindepth 2 -maxdepth 2 -name idea.yaml 2>/dev/null -exec sh -c 'sed -n "s/^status:[[:space:]]*\"\{0,1\}\([a-z_]*\).*/\1/p" "$1" | head -n1' _ {} \; 2>/dev/null | grep -Evc 'declined|aborted' || true)"
  prds_m="$(find product/prds -type f -name 'measurement*.yaml' 2>/dev/null | wc -l | tr -d ' ')"
  pend="$(find product/approvals/pending -maxdepth 1 -type f -name '*.yaml' ! -name '.gitkeep' 2>/dev/null | wc -l | tr -d ' ')"
  iters="$(find product/roadmap/iterations -maxdepth 1 -type f -name '*.yaml' 2>/dev/null | wc -l | tr -d ' ')"
  printf '\n━━━ riepilogo ━━━\n'
  printf 'idee totali: %s (attive, escl. declined/aborted: %s)\n' "${ideas:-0}" "${active:-0}"
  printf 'file measurement: %s · proposte in pending/: %s · piani di iterazione: %s\n' "${prds_m:-0}" "${pend:-0}" "${iters:-0}"
  printf 'generato: %s\n' "$(date +%Y-%m-%dT%H:%M:%S)"
}

case "$MODE" in
  sweep)
    printf '# governance-dump: sweep (Backlog Refinement) — SOLA LETTURA\n'
    emit_reference
    emit_ideas
    emit_glob "product/prds" 'measurement*.yaml'
    emit_iterations
    emit_pending
    footer
    ;;
  backlog)
    printf '# governance-dump: backlog — SOLA LETTURA\n'
    emit_file "product/reference/product-lines.yaml"
    emit_ideas
    emit_pending
    footer
    ;;
  ideas)
    printf '# governance-dump: ideas%s — SOLA LETTURA\n' "$([ "$INCLUDE_ALL" -eq 1 ] && printf ' (--all)')"
    emit_ideas
    footer
    ;;
  measurements)
    printf '# governance-dump: measurements — SOLA LETTURA\n'
    emit_glob "product/prds" 'measurement*.yaml'
    emit_ideas
    footer
    ;;
  iterations)
    printf '# governance-dump: iterations — SOLA LETTURA\n'
    emit_iterations
    ;;
  pending)
    printf '# governance-dump: pending — SOLA LETTURA\n'
    emit_pending
    ;;
  reference)
    printf '# governance-dump: reference — SOLA LETTURA\n'
    emit_reference
    ;;
  *)
    echo "Uso: governance-dump.sh sweep|backlog|ideas [--all]|measurements|iterations|pending|reference" >&2
    exit 2
    ;;
esac

exit 0
