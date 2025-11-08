#!/usr/bin/env bash
set -euo pipefail

WALLPAPER_DIR="$HOME/.config/backgrounds"

# Resolve symlink properly — this is the key fix
if ! REAL_DIR=$(realpath "$WALLPAPER_DIR" 2>/dev/null); then
  echo "Error: Cannot resolve $WALLPAPER_DIR"
  exit 1
fi

# Pick random wallpaper
FILE=$(find "$REAL_DIR" -type f \( \
  -iname "*.png" -o \
  -iname "*.jpg" -o \
  -iname "*.jpeg" -o \
  -iname "*.webp" \
  \) | shuf -n 1)

if [[ -z "$FILE" ]]; then
  echo "No wallpapers found in $REAL_DIR"
  exit 1
fi

# Start daemon if not running
pgrep -x swww-daemon >/dev/null || swww-daemon &

# Small delay to ensure socket is ready
sleep 0.3

echo "Setting wallpaper: $(basename "$FILE")"
swww img "$FILE" \
  --transition-type fade \
  --transition-duration 1 \
  --transition-fps 60 \
  --transition-step 90
