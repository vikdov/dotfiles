#!/usr/bin/env bash
set -euo pipefail

"$HOME/.config/hypr/scripts/random-lock-wallpaper.sh"
ART="$("$HOME/.config/hypr/scripts/lock-music.sh" --art 2>/dev/null || true)"
[[ -n "$ART" && -f "$ART" ]] && ln -sf "$ART" "$HOME/.cache/hyprlock-art/current.jpg"
exec hyprlock --grace 0
