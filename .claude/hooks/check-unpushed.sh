#!/usr/bin/env bash
# Promemoria (non bloccante) a fine turno Claude Code: segnala se il repo di
# governance corrente ha modifiche non committate o commit non pushati.
# Non esegue mai push/commit da solo — solo un promemoria testuale, sullo
# stesso principio di sola-allerta di .githooks/post-checkout.
#
# Pensato per i PM che lavorano su un'istanza forkata quasi solo tramite
# Claude Code e tendono a dimenticarsi il push a fine sessione/milestone.

set -uo pipefail

REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || true)"
[ -z "$REPO_ROOT" ] && exit 0
cd "$REPO_ROOT" || exit 0

DIRTY=0
if [ -n "$(git status --porcelain 2>/dev/null)" ]; then
  DIRTY=1
fi

UNPUSHED=0
if git rev-parse --abbrev-ref --symbolic-full-name '@{u}' >/dev/null 2>&1; then
  AHEAD="$(git rev-list '@{u}..HEAD' --count 2>/dev/null || echo 0)"
  case "$AHEAD" in
    ''|*[!0-9]*) AHEAD=0 ;;
  esac
  [ "$AHEAD" -gt 0 ] && UNPUSHED=1
fi

if [ "$DIRTY" = "1" ] || [ "$UNPUSHED" = "1" ]; then
  echo '{"systemMessage": "📤 Ci sono modifiche non committate o non pushate in questo repo di governance — ricorda commit/push prima di chiudere."}'
fi

exit 0
