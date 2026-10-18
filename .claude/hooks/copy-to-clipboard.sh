#!/usr/bin/env bash
# Copia stdin negli appunti del sistema, così il PM incolla una bozza di
# mail (risposta al richiedente, aggiornamento di delivery, avviso di
# conclusione) nel suo client di posta senza selezionarla dal terminale —
# dove l'a-capo visivo può diventare un a-capo vero nel testo copiato.
#
# Solo locale: non invia nulla a nessuno (l'invio resta un atto manuale
# del PM — playbook, "Testi che il PM manda a mano: visibili e pronti da
# copiare"). Usa il primo strumento disponibile tra pbcopy (macOS),
# wl-copy (Wayland), xclip / xsel (X11), clip.exe (Windows/WSL). Se
# nessuno c'è, lo dice ed esce 1: la bozza resta comunque mostrata in
# conversazione.
#
# Uso: bash .claude/hooks/copy-to-clipboard.sh <<'TESTO'
#      ...
#      TESTO

set -uo pipefail

TEXT="$(cat)"
# Niente a-capo finale in più: incollato nel client di posta sarebbe una
# riga vuota in coda.
TEXT="${TEXT%$'\n'}"

if command -v pbcopy >/dev/null 2>&1; then
  printf '%s' "$TEXT" | pbcopy
elif [ -n "${WAYLAND_DISPLAY:-}" ] && command -v wl-copy >/dev/null 2>&1; then
  printf '%s' "$TEXT" | wl-copy
elif command -v xclip >/dev/null 2>&1; then
  printf '%s' "$TEXT" | xclip -selection clipboard
elif command -v xsel >/dev/null 2>&1; then
  printf '%s' "$TEXT" | xsel --clipboard --input
elif command -v clip.exe >/dev/null 2>&1; then
  printf '%s' "$TEXT" | clip.exe
else
  echo "Nessuno strumento per gli appunti trovato (pbcopy, wl-copy, xclip, xsel, clip.exe): copia il testo dalla conversazione." >&2
  exit 1
fi

echo "Copiato negli appunti ($(printf '%s' "$TEXT" | wc -c | tr -d ' ') caratteri)."
