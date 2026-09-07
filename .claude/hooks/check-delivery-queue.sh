#!/usr/bin/env bash
# Promemoria (non bloccante): quante transizioni di delivery rilevate da
# delivery-watch aspettano una decisione del PM (smarcare la coda di
# triage), e da quanto tempo delivery-watch non gira.
#
# Perché serve. delivery-watch scrive gli eventi del tracker di esecuzione
# (bug risolto, in sviluppo, bloccata, in produzione, regressione) in una
# coda di triage in product/reference/delivery-watch.yaml che SOPRAVVIVE
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

# Voci di coda ancora da smarcare.
PENDING="$(grep -cE '^[[:space:]]*triage_status:[[:space:]]*pending[[:space:]]*$' "$STATE" 2>/dev/null || true)"
case "$PENDING" in ''|*[!0-9]*) PENDING=0 ;; esac

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
if [ "$PENDING" -eq 0 ] && { [ -z "$DAYS" ] || [ "$DAYS" -lt 7 ]; }; then
  exit 0
fi

MSG="🚚 delivery-watch:"
if [ "$PENDING" -gt 0 ]; then
  if [ "$PENDING" -eq 1 ]; then N="transizione di delivery da smarcare"; else N="transizioni di delivery da smarcare"; fi
  MSG="$MSG $PENDING $N in \`product/reference/delivery-watch.yaml\`"
else
  MSG="$MSG coda di triage vuota"
fi
[ -n "$DAYS" ] && MSG="$MSG · ultimo giro $DAYS gg fa ($RUN_AT)"

if [ "$PENDING" -ge 5 ] || { [ -n "$DAYS" ] && [ "$DAYS" -ge 7 ]; }; then
  MSG="$MSG · lancia \`delivery-watch\` per aggiornare, poi smarca la coda decidendo per ciascun evento se mandare una mail agli stakeholder (nessun invio automatico)."
else
  MSG="$MSG · \`delivery-watch\` per rivedere."
fi

# JSON-escape minimale (\ e "), come check-connectors.sh.
esc_json() {
  printf '%s' "$1" | tr '\n' ' ' | sed 's/\\/\\\\/g; s/"/\\"/g'
}

printf '{"systemMessage": "%s"}\n' "$(esc_json "$MSG")"
exit 0
