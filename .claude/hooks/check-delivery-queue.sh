#!/usr/bin/env bash
# Promemoria (non bloccante): quante transizioni di delivery rilevate da
# delivery-watch aspettano il PM — bozze di mail pronte da mandare
# (drafted) e voci da smarcare (pending) — e da quanto tempo
# delivery-watch non gira.
#
# Perché serve. delivery-watch scrive gli eventi del tracker di esecuzione
# (bug risolto, in sviluppo, bloccata, in produzione, regressione) in una
# coda in product/reference/delivery-watch.yaml che SOPRAVVIVE
# tra le sessioni — così il PM non ne perde nessuno. Ma niente la rende
# visibile: `git status` è pulito (il file È committato), e la coda si
# guarda solo lanciando delivery-watch.
#
# Simmetrico a check-pending-approvals.sh / check-inbox.sh: solo un
# systemMessage, nessun invio, nessuna bozza — le decisioni (e ogni mail)
# sono sempre del PM. Attivo anche in dry-run.
#
# No-op: canonico / istanza non inizializzata (manca .governance/config.yaml),
# tracker non configurato (jira.configured != true), o file di stato assente
# (delivery-watch non è mai girato).

set -uo pipefail

REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || true)"
[ -z "$REPO_ROOT" ] && exit 0
cd "$REPO_ROOT" || exit 0

[ -f ".governance/config.yaml" ] || exit 0   # canonico o istanza non inizializzata

# Tracker collegato? (blocco jira:, campo configured: true) — parsing
# best-effort come check-connectors.sh.
JIRA_ON="$(awk '
  /^jira:[[:space:]]*$/ { inblk=1; next }
  /^[^[:space:]#]/ { inblk=0 }
  inblk && /^[[:space:]]*configured:[[:space:]]*true([[:space:]]*#.*)?$/ { print "1"; exit }
' .governance/config.yaml)"
[ "$JIRA_ON" = "1" ] || exit 0

STATE="product/reference/delivery-watch.yaml"
[ -f "$STATE" ] || exit 0

# Voci di coda ancora aperte: bozze pronte da mandare + voci da smarcare.
count_status() {
  local n
  n="$(grep -cE "^[[:space:]]*(- )?triage_status:[[:space:]]*$1[[:space:]]*(#.*)?$" "$STATE" 2>/dev/null || true)"
  case "$n" in ''|*[!0-9]*) n=0 ;; esac
  printf '%s' "$n"
}
DRAFTED="$(count_status drafted)"
PENDING="$(count_status pending)"
OPEN=$(( DRAFTED + PENDING ))

# Giorni dall'ultimo giro (last_watch.run_at, prime 10 cifre della data).
RUN_AT="$(sed -n 's/^[[:space:]]*run_at:[[:space:]]*"\{0,1\}\([0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\}\).*/\1/p' "$STATE" | head -n1)"
DAYS=""
if [ -n "$RUN_AT" ]; then
  EPOCH="$(date -d "$RUN_AT" +%s 2>/dev/null || date -j -f "%Y-%m-%d" "$RUN_AT" +%s 2>/dev/null || echo "")"
  if [ -n "$EPOCH" ]; then
    DAYS=$(( ( $(date +%s) - EPOCH ) / 86400 ))
    [ "$DAYS" -lt 0 ] && DAYS=0
  fi
fi

# Niente in coda e giro recente → silenzio.
if [ "$OPEN" -eq 0 ] && { [ -z "$DAYS" ] || [ "$DAYS" -lt 7 ]; }; then
  exit 0
fi

MSG="🚚 delivery-watch:"
if [ "$OPEN" -gt 0 ]; then
  PARTS=""
  if [ "$DRAFTED" -gt 0 ]; then
    if [ "$DRAFTED" -eq 1 ]; then PARTS="1 mail agli stakeholder pronta da mandare"; else PARTS="$DRAFTED mail agli stakeholder pronte da mandare"; fi
  fi
  if [ "$PENDING" -gt 0 ]; then
    [ -n "$PARTS" ] && PARTS="$PARTS + "
    if [ "$PENDING" -eq 1 ]; then PARTS="${PARTS}1 voce da smarcare"; else PARTS="${PARTS}$PENDING voci da smarcare"; fi
  fi
  MSG="$MSG $PARTS in \`product/reference/delivery-watch.yaml\`"
else
  MSG="$MSG coda di triage vuota"
fi
[ -n "$DAYS" ] && MSG="$MSG · ultimo giro $DAYS gg fa ($RUN_AT)"

if [ "$OPEN" -ge 5 ] || { [ -n "$DAYS" ] && [ "$DAYS" -ge 7 ]; }; then
  MSG="$MSG · lancia \`delivery-watch\` per aggiornare, poi smarca la coda: ogni movimento di una card ha la sua mail, la mandi tu (nessun invio automatico)."
else
  MSG="$MSG · \`delivery-watch\` per rivedere."
fi

# JSON-escape minimale (\ e "), come check-connectors.sh.
esc_json() {
  printf '%s' "$1" | tr '\n' ' ' | sed 's/\\/\\\\/g; s/"/\\"/g'
}

printf '{"systemMessage": "%s"}\n' "$(esc_json "$MSG")"
exit 0
