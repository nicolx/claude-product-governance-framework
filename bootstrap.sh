#!/usr/bin/env bash
# Bootstrap di una nuova ISTANZA del framework di Product Governance.
#
# Va eseguito una sola volta, subito dopo aver clonato il PROPRIO FORK
# (non il repo canonico) del framework:
#
#   git clone <url-del-tuo-fork>
#   cd <cartella>
#   ./bootstrap.sh
#
# Cosa fa:
#   1. Verifica che 'origin' NON sia il repo canonico del framework
#      (se lo è, ti sta dicendo che hai clonato il canonico invece del tuo
#      fork: va fermato subito, prima che tu possa fare danni con un push).
#   2. Attiva gli hook versionati in .githooks/ (core.hooksPath).
#   3. Aggiunge il remote 'upstream' puntato al canonico, per poter tirare
#      giù in futuro gli aggiornamenti del metodo con la skill
#      sync-framework-updates.
#   4. Se l'istanza non è ancora inizializzata, ti indica il prossimo passo.
#
# Questo script è un livello di comodità/allerta precoce, NON la vera
# protezione: quella vive lato server, come branch protection sul repo
# canonico (vedi README.md, sezione "Protezione del repo canonico").

set -euo pipefail

REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || true)"
if [ -z "$REPO_ROOT" ]; then
  echo "Errore: non sembra di essere dentro un repository git." >&2
  exit 1
fi
cd "$REPO_ROOT"

CANONICAL_FILE="framework/canonical-remote.txt"
if [ ! -f "$CANONICAL_FILE" ]; then
  echo "Errore: manca $CANONICAL_FILE. Questo script va eseguito dalla root del framework/fork." >&2
  exit 1
fi

normalize() {
  # Rimuove commenti/righe vuote, protocollo git@ vs https, suffisso .git, spazi
  printf '%s' "$1" \
    | sed -E 's#^git@github\.com:#https://github.com/#' \
    | sed -E 's#\.git/?$##' \
    | tr -d '[:space:]'
}

CANONICAL_URL="$(grep -vE '^\s*#' "$CANONICAL_FILE" | grep -vE '^\s*$' | head -n1)"
CANONICAL_NORM="$(normalize "$CANONICAL_URL")"

if [[ "$CANONICAL_NORM" == *PLACEHOLDER-ORG* ]]; then
  echo "⚠️  framework/canonical-remote.txt contiene ancora il placeholder."
  echo "    Non posso verificare se questo è il repo canonico o un fork."
  echo "    Aggiornalo con l'URL reale non appena il framework è su GitHub."
  echo ""
fi

ORIGIN_URL="$(git remote get-url origin 2>/dev/null || true)"
if [ -z "$ORIGIN_URL" ]; then
  echo "⚠️  Nessun remote 'origin' configurato: non posso verificare se sei su un fork."
else
  ORIGIN_NORM="$(normalize "$ORIGIN_URL")"
  if [ "$ORIGIN_NORM" = "$CANONICAL_NORM" ]; then
    echo "🚫 STOP: 'origin' punta al repo CANONICO del framework, non a un fork."
    echo ""
    echo "   Non lavorare direttamente qui. Il flusso corretto è:"
    echo "     1. Fai 'Fork' del repo canonico su GitHub"
    echo "     2. Clona il TUO fork (non il canonico)"
    echo "     3. Rilancia ./bootstrap.sh dentro il fork"
    echo ""
    exit 1
  fi
fi

# 2. Attiva gli hook versionati
git config core.hooksPath .githooks
chmod +x .githooks/* 2>/dev/null || true
echo "✅ Hook attivati (core.hooksPath = .githooks)"

# 3. Aggiunge/aggiorna il remote 'upstream'
if git remote get-url upstream >/dev/null 2>&1; then
  echo "ℹ️  Remote 'upstream' già presente: $(git remote get-url upstream)"
else
  if [[ "$CANONICAL_NORM" != *PLACEHOLDER-ORG* ]]; then
    git remote add upstream "$CANONICAL_URL"
    echo "✅ Remote 'upstream' aggiunto: $CANONICAL_URL"
  else
    echo "⚠️  Remote 'upstream' non aggiunto (canonical-remote.txt è ancora un placeholder)."
  fi
fi

# 4. Prossimo passo
echo ""
if [ -f ".governance/config.yaml" ]; then
  echo "✅ Istanza già inizializzata (.governance/config.yaml presente)."
else
  echo "➡️  Prossimo passo: apri Claude Code in questa cartella e lancia la skill"
  echo "    'init-governance-project' per fare l'intervista di inizializzazione"
  echo "    (PM assegnati, stakeholder, repo applicativi da collegare, Jira, ecc.)."
fi
