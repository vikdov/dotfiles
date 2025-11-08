#!/usr/bin/env bash
set -euo pipefail

WALLPAPER_DIR="$HOME/.config/backgrounds"
LOCK_IMAGE="/tmp/lock_wallpaper"
FALLBACK="$HOME/.config/backgrounds/a_city_skyline_with_a_tall_building.jpg"

# Pick random image
FILE=$(find "$WALLPAPER_DIR" -type f \( -iname "*.png" -o -iname "*.jpg" -o -iname "*.jpeg" \) | shuf -n 1)

# Fallback
[[ -z "$FILE" || ! -f "$FILE" ]] && FILE="$FALLBACK"

# Fast copy (no processing)
cp "$FILE" "$LOCK_IMAGE"

# Ensure readable
chmod 644 "$LOCK_IMAGE"

# Optional: silent notification
# notify-send -u low "Lock WP" "$(basename "$FILE")" -t 1000
