#!/usr/bin/env bash
set -euo pipefail

WP_SCRIPT="$HOME/.config/hypr/scripts/random-lock-wallpaper.sh"
LOCK_IMAGE="/tmp/lock_wallpaper.jpg"

"$WP_SCRIPT"

# Wait max 1 second for a proper image
for i in {1..20}; do
  [[ -f "$LOCK_IMAGE" && $(stat -c%s "$LOCK_IMAGE") -gt 20000 ]] && break
  sleep 0.05
done

exec hyprlock
