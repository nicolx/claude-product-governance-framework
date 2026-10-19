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
#   governance-dump.sh sweep         # tutto il quadro per il Backlog Refinement (default; + scarti con risposta non inviata, team.yaml, ultimo snapshot, report distribuiti)
#   governance-dump.sh backlog       # idee + coda di approvazione + ultimo snapshot (slot_plan) (per backlog-list)
#   governance-dump.sh ideas [--all] # le idea.yaml (attive; --all include declined/aborted)
#   governance-dump.sh measurements  # product/prds/*/measurement*.yaml + idee + ultimo snapshot (slot_plan)
#   governance-dump.sh iterations    # gli ultimi due product/roadmap/iterations/*.yaml + ultimo snapshot (slot_plan, per iteration-board)
#   governance-dump.sh pending       # contenuto di product/approvals/pending/*.yaml
#   governance-dump.sh reference     # product/reference/*.yaml
#   governance-dump.sh delivery      # delivery-watch.yaml + product-lines.yaml + le idea.yaml + ultimo snapshot (per delivery-watch)
#   governance-dump.sh reports       # viste dichiarate + ultimi report + tutte le fonti dei modelli (ultimi due snapshot) + ultime cerimonie + indice pending (per report-render)
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

emit_closed_with_drafted_replies() {
  # idee declined/aborted (escluse da emit_ideas) con una risposta al
  # richiedente ancora da inviare: uno scarto non comunicato lascia il
  # richiedente appeso (playbook, "Chiudere il loop col richiedente")
  local d st
  [ -d "product/ideas" ] || return 0
  [ "$INCLUDE_ALL" -eq 1 ] && return 0
  find product/ideas -mindepth 2 -maxdepth 2 -name idea.yaml 2>/dev/null | sort | while IFS= read -r d; do
    st="$(idea_status "$d")"
    case "$st" in
      declined|aborted) ;;
      *) continue ;;
    esac
    grep -qE '^[[:space:]-]*reply_status:[[:space:]]*"?drafted"?[[:space:]]*(#.*)?$' "$d" 2>/dev/null || continue
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
  emit_file "product/reference/delivery-watch.yaml"
  emit_file "product/reference/reporting-models.yaml"
  emit_file "product/reference/team.yaml"          # offerta di capacità per competenza (capacity_check, slot_plan)
}

emit_latest_snapshot() {
  # l'ultimo snapshot di roadmap approvato
  local f
  [ -d "product/roadmap/snapshots" ] || return 0
  f="$(find product/roadmap/snapshots -maxdepth 1 -type f -name '*.yaml' 2>/dev/null | sort | tail -n 1)"
  [ -n "$f" ] && emit_file "$f"
}

emit_last_two_snapshots() {
  # gli ultimi due snapshot approvati: l'aggiornamento settimanale confronta
  # gli slot_plan per dire cosa si è spostato
  [ -d "product/roadmap/snapshots" ] || return 0
  find product/roadmap/snapshots -maxdepth 1 -type f -name '*.yaml' 2>/dev/null | sort | tail -n 2 \
    | while IFS= read -r f; do emit_file "$f"; done
}

emit_distributed_reports() {
  # le comunicazioni di report già approvate (decided/, outbound_comm
  # approved): solo i metadati — vista, periodo, fonti, data — non il
  # corpo. Servono all'aggiornamento settimanale per ritrovare su quale
  # snapshot poggiava la roadmap trimestrale distribuita (la "promessa")
  local f
  [ -d "product/approvals/decided" ] || return 0
  printf '\n━━━ report distribuiti (outbound_comm approvati, solo metadati) ━━━\n'
  grep -l '^type:[[:space:]]*outbound_comm' product/approvals/decided/*.yaml 2>/dev/null \
    | xargs grep -l '^decision:[[:space:]]*approved' 2>/dev/null | sort \
    | while IFS= read -r f; do
        printf -- '- %s\n' "$f"
        sed -n -E '/^[[:space:]]*(view|period|report_ref|decided_at):/p; /^[[:space:]]*sources:/,/^[[:space:]]*[a-z_]+:/{/^[[:space:]]*- /p;}' "$f" | sed 's/^/    /'
      done
}

emit_reports_index() {
  # per ogni vista in product/reports/, il periodo dell'ultimo report generato
  # (serve a capire quali viste sono in scadenza — non il contenuto)
  local d last
  [ -d "product/reports" ] || return 0
  printf '\n━━━ product/reports (ultimo report per vista) ━━━\n'
  find product/reports -mindepth 1 -maxdepth 1 -type d 2>/dev/null | sort | while IFS= read -r d; do
    last="$(find "$d" -maxdepth 1 -type f -name '*.md' 2>/dev/null | sort | tail -n 1)"
    printf '%s: %s\n' "${d#product/reports/}" "${last:+$(basename "$last" .md)}"
  done
}

emit_recent_ceremonies() {
  # il registro (decisions.yaml) delle ultime 2 cerimonie per tipo, escluse
  # quelle annullate (-void): fonte dei commenti delle viste di roadmap
  local t f
  [ -d "product/ceremonies" ] || return 0
  find product/ceremonies -mindepth 1 -maxdepth 1 -type d 2>/dev/null | sort | while IFS= read -r t; do
    find "$t" -mindepth 1 -maxdepth 1 -type d ! -name '*-void' 2>/dev/null | sort | tail -n 2 \
      | while IFS= read -r f; do emit_file "$f/decisions.yaml"; done
  done
}

emit_pending_index() {
  # solo i nomi delle proposte in coda: una vista dichiara cosa è ancora in
  # attesa, non ne legge il contenuto
  [ -d "product/approvals/pending" ] || return 0
  printf '\n━━━ product/approvals/pending (indice) ━━━\n'
  find product/approvals/pending -maxdepth 1 -type f -name '*.yaml' 2>/dev/null | sort | sed 's#.*/##'
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
    emit_closed_with_drafted_replies
    emit_glob "product/prds" 'measurement*.yaml'
    emit_iterations
    emit_latest_snapshot   # slot_plan precedente: le iniziative in sviluppo ne ereditano lo slot
    emit_distributed_reports  # la roadmap trimestrale distribuita: la promessa contro cui misurare gli slot
    emit_pending
    emit_reports_index
    footer
    ;;
  backlog)
    printf '# governance-dump: backlog — SOLA LETTURA\n'
    emit_file "product/reference/product-lines.yaml"
    emit_ideas
    emit_pending
    emit_latest_snapshot   # slot_plan: quando ogni idea prioritizzata può partire con il team attuale
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
    emit_latest_snapshot   # slot_plan: i rilasci in arrivo, per preparare la misurazione prima che sia tardi
    footer
    ;;
  iterations)
    printf '# governance-dump: iterations — SOLA LETTURA\n'
    emit_iterations
    emit_latest_snapshot   # slot_plan: quando parte / finisce ogni voce della board
    ;;
  pending)
    printf '# governance-dump: pending — SOLA LETTURA\n'
    emit_pending
    ;;
  reference)
    printf '# governance-dump: reference — SOLA LETTURA\n'
    emit_reference
    ;;
  delivery)
    printf '# governance-dump: delivery (delivery-watch) — SOLA LETTURA\n'
    emit_file "product/reference/delivery-watch.yaml"
    emit_file "product/reference/product-lines.yaml"
    emit_ideas
    emit_latest_snapshot   # slot_plan: ogni movimento confrontato con lo slot previsto
    footer
    ;;
  reports)
    printf '# governance-dump: reports (report-render) — SOLA LETTURA\n'
    emit_reference
    emit_reports_index
    emit_ideas
    emit_glob "product/prds" 'measurement*.yaml'
    emit_iterations
    emit_last_two_snapshots   # corrente + precedente: confronto degli slot nell'aggiornamento settimanale
    emit_distributed_reports  # base del confronto con la roadmap trimestrale distribuita
    emit_recent_ceremonies
    emit_pending_index
    footer
    ;;
  *)
    echo "Uso: governance-dump.sh sweep|backlog|ideas [--all]|measurements|iterations|pending|reference|delivery|reports" >&2
    exit 2
    ;;
esac

exit 0
