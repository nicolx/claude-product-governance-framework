#!/usr/bin/env bash
# Promemoria (non bloccante): quante bozze di risposta a chi ha mandato
# materiale all'intake (requester_reply, followup_replies) sono pronte ma
# non ancora inviate.
#
# Perché serve. Il metodo vuole che nessun richiedente resti appeso
# (playbook, "Chiudere il loop col richiedente"): ogni intake produce una
# bozza, il PM la manda a mano. Ma una bozza scritta in idea.yaml e mai
# inviata lascia il richiedente al buio quanto nessuna bozza — e niente lo
# rende visibile: il file è committato, git status è pulito.
#
# Simmetrico a check-conclusion-notices.sh: solo un systemMessage, nessun
# invio — ogni mail la manda il PM. Attivo anche in dry-run.
#
# No-op: canonico / istanza non inizializzata (manca .governance/config.yaml)
# o nessuna bozza in sospeso.

set -uo pipefail

REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || true)"
[ -z "$REPO_ROOT" ] && exit 0
cd "$REPO_ROOT" || exit 0

[ -f ".governance/config.yaml" ] || exit 0   # canonico o istanza non inizializzata
[ -d "product/ideas" ] || exit 0

# reply_status è una chiave dedicata a requester_reply/followup_replies,
# non collide con lo status dell'idea né con notice_status.
PENDING=0
IDEAS=0
for f in product/ideas/*/idea.yaml; do
  [ -f "$f" ] || continue
  N="$(grep -cE '^[[:space:]-]*reply_status:[[:space:]]*"?drafted"?[[:space:]]*(#.*)?$' "$f" 2>/dev/null || true)"
  case "$N" in ''|*[!0-9]*) N=0 ;; esac
  if [ "$N" -gt 0 ]; then
    PENDING=$(( PENDING + N ))
    IDEAS=$(( IDEAS + 1 ))
  fi
done

[ "$PENDING" -eq 0 ] && exit 0

if [ "$PENDING" -eq 1 ]; then N="bozza di risposta non ancora inviata"; else N="bozze di risposta non ancora inviate"; fi
if [ "$IDEAS" -eq 1 ]; then I="1 idea"; else I="$IDEAS idee"; fi
MSG="✉️ risposte ai richiedenti: $PENDING $N ($I, \`reply_status: drafted\`) · finché non parte, chi ha scritto resta al buio. Mandale tu e dichiarale inviate (sent), o esentale con un motivo (waived)."

# JSON-escape minimale (\ e "), come check-connectors.sh.
esc_json() {
  printf '%s' "$1" | tr '\n' ' ' | sed 's/\\/\\\\/g; s/"/\\"/g'
}

printf '{"systemMessage": "%s"}\n' "$(esc_json "$MSG")"
exit 0
