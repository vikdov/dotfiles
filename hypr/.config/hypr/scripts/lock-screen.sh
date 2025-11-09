#!/usr/bin/env bash
set -euo pipefail

"$HOME/.config/hypr/scripts/random-lock-wallpaper.sh"
exec hyprlock --immediate
