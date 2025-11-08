#!/usr/bin/env bash
set -euo pipefail
for i in {1..15}; do
  [[ -S "$XDG_RUNTIME_DIR/swww.socket" ]] || [[ -S "/tmp/swww.socket" ]] && break
  sleep 1
done
exec "$HOME/.config/hypr/scripts/random-wallpaper.sh" --force
