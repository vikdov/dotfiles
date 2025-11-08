#!/usr/bin/env bash
set -euo pipefail

# Directory with wallpapers
WALLPAPER_DIR="$HOME/.config/backgrounds"

# Pick a random image (png, jpg, jpeg)
FILE=$(find "$WALLPAPER_DIR" -type f \( -iname "*.png" -o -iname "*.jpg" -o -iname "*.jpeg" \) | shuf -n 1)

# Start swww daemon if not running
pgrep -x swww-daemon >/dev/null || swww-daemon &

# Wait briefly for socket
sleep 0.5

# Set wallpaper with fade transition
swww img "$FILE" --transition-type fade --transition-step 90 --transition-duration 1 --transition-fps 60
