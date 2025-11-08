#!/usr/bin/env bash
set -euo pipefail

LOCK_IMAGE="/tmp/lock_wallpaper"
WP_SCRIPT="$HOME/.config/hypr/scripts/random-lock-wallpaper.sh"

# Run wallpaper script in background
"$WP_SCRIPT" & # ← Non-blocking!

# Launch hyprlock immediately
exec hyprlock
