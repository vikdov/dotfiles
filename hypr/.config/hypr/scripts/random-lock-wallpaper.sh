#!/usr/bin/env bash
set -euo pipefail

DIR="$(realpath ~/.config/backgrounds)"
IMG="$(find "$DIR" -type f \( -iname "*.png" -o -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.webp" \) -print0 |
  shuf -z -n1 | tr -d '\0')"

rm -f /tmp/lock_wallpaper.jpg
if command -v magick >/dev/null 2>&1; then
  magick "$IMG" -strip -background black -flatten -quality 95 /tmp/lock_wallpaper.jpg
else
  convert "$IMG" -strip -background black -flatten -quality 95 /tmp/lock_wallpaper.jpg 2>/dev/null || cp -f "$IMG" /tmp/lock_wallpaper.jpg
fi
