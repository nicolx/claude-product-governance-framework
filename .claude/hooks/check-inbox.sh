#!/usr/bin/env bash
# Promemoria (non bloccante) a fine turno Claude Code: segnala se
# product/inbox/ contiene materiale grezzo non ancora processato da
# inbox-triage.
#
# product/inbox/ non è tracciata da git (vedi .gitignore): se un PM ci
# droppa un'email/thread/allegato e non lancia inbox-triage, quel
# materiale non compare mai in `git status` né in nessun altro segnale
# visibile — è un buco silenzioso simmetrico a quello che check-unpushed.sh
# risolve per commit/push. Questo hook non processa nulla da solo: solo un
# messaggio testuale, stesso principio di sola-allerta.

set -uo pipefail

REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || true)"
[ -z "$REPO_ROOT" ] && exit 0
INBOX="$REPO_ROOT/product/inbox"
[ -d "$INBOX" ] || exit 0

# Conta ogni voce dentro l'inbox (file o cartella) tranne .gitkeep e
# artefatti di sistema noti. maxdepth/mindepth 1: contiamo gli elementi
# droppati, non il loro contenuto (un export Slack può essere una cartella).
COUNT=$(find "$INBOX" -mindepth 1 -maxdepth 1 \
  ! -name ".gitkeep" ! -name ".DS_Store" | wc -l | tr -d ' ')
case "$COUNT" in
  ''|*[!0-9]*) COUNT=0 ;;
esac

if [ "$COUNT" -gt 0 ]; then
  echo "{\"systemMessage\": \"📥 product/inbox/ contiene $COUNT elemento/i non ancora processato/i — valuta di lanciare inbox-triage prima di chiudere.\"}"
fi

exit 0
