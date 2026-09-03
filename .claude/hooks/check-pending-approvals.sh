#!/usr/bin/env bash
# Promemoria (non bloccante) per Claude Code: segnala quante proposte
# giacciono in product/approvals/pending/ in attesa di una decisione umana,
# da quanto tempo, e di che tipo.
#
# Perché serve. La coda `pending/` è l'unico punto in cui un diff di RICE,
# uno snapshot di roadmap, una Strategic Exception o una comunicazione in
# uscita passano da "proposti" a "effettivi" (playbook, "Regola non
# negoziabile: pending approval"). Se nessuno la svuota tra una cerimonia
# e l'altra, si arriva al Backlog Refinement con decine di proposte
# arretrate e la prioritizzazione gira su un ranking incompleto — proprio
# la situazione che il gate dovrebbe evitare. Nessun altro segnale la
# rende visibile: `git status` è pulito (i file SONO committati), e la
# coda si guarda solo lanciando `pending-approval` o `backlog-list`.
#
# Simmetrico a check-inbox.sh / check-unpushed.sh: solo un messaggio
# testuale, non applica né approva nulla (le decisioni sono sempre umane
# ed esplicite, voce per voce). Attivo anche in dry-run — riporta lavoro
# arretrato da run precedenti, non va silenziato.
#
# No-op sul canonico / su un'istanza non inizializzata (manca
# .governance/config.yaml) e se la cartella pending/ non esiste.

set -uo pipefail

REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || true)"
[ -z "$REPO_ROOT" ] && exit 0
cd "$REPO_ROOT" || exit 0

[ -f ".governance/config.yaml" ] || exit 0   # canonico o istanza non inizializzata
PENDING="product/approvals/pending"
[ -d "$PENDING" ] || exit 0

# Elenca le proposte in coda (file .yaml, esclusi .gitkeep e affini).
FILES=$(find "$PENDING" -mindepth 1 -maxdepth 1 -type f -name '*.yaml' ! -name '.gitkeep' 2>/dev/null)
[ -z "$FILES" ] && exit 0

COUNT=$(printf '%s\n' "$FILES" | grep -c .)

# Ripartizione per tipo: rice_diff vs. tutto il resto (roadmap_snapshot,
# strategic_exception_flag, mandate_update, mandate_reclassification,
# outbound_comm).
RICE=0
OTHER=0
OLDEST_DATE=""
while IFS= read -r f; do
  [ -z "$f" ] && continue
  TYPE=$(sed -n 's/^type:[[:space:]]*"\{0,1\}\([a-z_]*\).*/\1/p' "$f" | head -n1)
  if [ "$TYPE" = "rice_diff" ]; then
    RICE=$((RICE + 1))
  else
    OTHER=$((OTHER + 1))
  fi
  D=$(sed -n 's/^proposed_at:[[:space:]]*"\{0,1\}\([0-9-]*\).*/\1/p' "$f" | head -n1)
  if [ -n "$D" ]; then
    if [ -z "$OLDEST_DATE" ] || [ "$D" \< "$OLDEST_DATE" ]; then
      OLDEST_DATE="$D"
    fi
  fi
done <<EOF
$FILES
EOF

# Età della proposta più vecchia, in giorni (best-effort, GNU o BSD date).
OLDEST_DAYS=""
if [ -n "$OLDEST_DATE" ]; then
  EPOCH=$(date -d "$OLDEST_DATE" +%s 2>/dev/null || date -j -f "%Y-%m-%d" "$OLDEST_DATE" +%s 2>/dev/null || echo "")
  if [ -n "$EPOCH" ]; then
    OLDEST_DAYS=$(( ( $(date +%s) - EPOCH ) / 86400 ))
    [ "$OLDEST_DAYS" -lt 0 ] && OLDEST_DAYS=0
  fi
fi

# Composizione del messaggio.
if [ "$COUNT" -eq 1 ]; then NOUN="proposta"; else NOUN="proposte"; fi
if [ "$RICE" -gt 0 ] && [ "$OTHER" -eq 0 ]; then
  NOUN="$NOUN RICE"
fi
MSG="📋 $COUNT $NOUN in \`product/approvals/pending/\` in attesa di decisione"
if [ "$RICE" -gt 0 ] && [ "$OTHER" -gt 0 ]; then
  if [ "$OTHER" -eq 1 ]; then ONOUN="altra"; else ONOUN="altre"; fi
  MSG="$MSG ($RICE RICE, $OTHER $ONOUN)"
fi
if [ -n "$OLDEST_DAYS" ]; then
  if [ "$OLDEST_DAYS" -eq 1 ]; then DNOUN="giorno"; else DNOUN="giorni"; fi
  MSG="$MSG — la più vecchia da $OLDEST_DAYS $DNOUN ($OLDEST_DATE)"
elif [ -n "$OLDEST_DATE" ]; then
  MSG="$MSG — la più vecchia dal $OLDEST_DATE"
fi

# Escalation: una coda ampia o stantia non dovrebbe sopravvivere tra due
# cerimonie.
STALE=0
[ -n "$OLDEST_DAYS" ] && [ "$OLDEST_DAYS" -ge 14 ] && STALE=1
if [ "$COUNT" -ge 5 ] || [ "$STALE" -eq 1 ]; then
  MSG="$MSG · la coda non dovrebbe accumularsi tra una cerimonia e l'altra: valuta \`pending-approval\` ora, non aspettare il prossimo Backlog Refinement."
else
  MSG="$MSG · \`pending-approval\` per la revisione."
fi

# Output JSON (systemMessage), come check-inbox.sh / check-unpushed.sh.
printf '{"systemMessage": "%s"}\n' "$MSG"
exit 0
