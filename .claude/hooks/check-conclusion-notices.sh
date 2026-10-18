#!/usr/bin/env bash
# Promemoria (non bloccante): quante conclusioni di iniziativa (consegna in
# produzione, chiusura della misurazione, interruzione) sono state rilevate
# ma non ancora comunicate agli stakeholder.
#
# Perché serve. Per il metodo una conclusione avviene quando è comunicata
# (playbook, "Avvisare gli stakeholder della conclusione"): status: done /
# aborted e closure.closed: true si scrivono solo quando la voce
# corrispondente di conclusion_notices sull'idea è sent o waived. Finché
# resta pending/drafted l'idea è "conclusa ma non avvisata" — e niente lo
# rende visibile: il file è committato, git status è pulito.
#
# Simmetrico a check-delivery-queue.sh: solo un systemMessage, nessun
# invio, nessuna bozza — ogni mail la manda il PM. Attivo anche in dry-run.
#
# No-op: canonico / istanza non inizializzata (manca .governance/config.yaml)
# o nessuna idea con un avviso in sospeso.

set -uo pipefail

REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || true)"
[ -z "$REPO_ROOT" ] && exit 0
cd "$REPO_ROOT" || exit 0

[ -f ".governance/config.yaml" ] || exit 0   # canonico o istanza non inizializzata
[ -d "product/ideas" ] || exit 0

# Voci in sospeso, su tutte le idee (notice_status è una chiave dedicata,
# non collide con lo status dell'idea).
PENDING=0
IDEAS=0
for f in product/ideas/*/idea.yaml; do
  [ -f "$f" ] || continue
  N="$(grep -cE '^[[:space:]-]*notice_status:[[:space:]]*"?(pending|drafted)"?[[:space:]]*(#.*)?$' "$f" 2>/dev/null || true)"
  case "$N" in ''|*[!0-9]*) N=0 ;; esac
  if [ "$N" -gt 0 ]; then
    PENDING=$(( PENDING + N ))
    IDEAS=$(( IDEAS + 1 ))
  fi
done

[ "$PENDING" -eq 0 ] && exit 0

if [ "$PENDING" -eq 1 ]; then N="conclusione da comunicare agli stakeholder"; else N="conclusioni da comunicare agli stakeholder"; fi
if [ "$IDEAS" -eq 1 ]; then I="1 idea"; else I="$IDEAS idee"; fi
MSG="📣 avvisi di conclusione: $PENDING $N ($I, \`conclusion_notices\` pending/drafted) · l'idea non passa a done/aborted, né la misurazione a chiusa, finché l'avviso non è inviato (sent) o esentato con motivo (waived). Nessun invio automatico: la mail la mandi tu."

# JSON-escape minimale (\ e "), come check-connectors.sh.
esc_json() {
  printf '%s' "$1" | tr '\n' ' ' | sed 's/\\/\\\\/g; s/"/\\"/g'
}

printf '{"systemMessage": "%s"}\n' "$(esc_json "$MSG")"
exit 0
