#!/usr/bin/env bash
# Prevent multiple instances
pgrep -x wofi && pkill -x wofi && exit 0

declare -A actions=(
  ["󰍁 Lock"]="~/.config/hypr/scripts/lock-screen.sh"
  ["󰍃 Logout"]="hyprctl dispatch exit"
  ["󰜉 Reboot"]="systemctl reboot"
  ["󰤆 Shutdown"]="systemctl poweroff"
)

choice=$(
  printf "%s\n" "${!actions[@]}" | wofi \
    --show dmenu \
    --prompt "Power" \
    --width 420 \
    --height 220 \
    --lines 4 \
    --location center \
    --anchor center \
    --insensitive \
    --cache-file /dev/null \
    --normal-window \
    --hide-scroll
)

[[ -z "$choice" ]] && exit 0
eval ${actions[$choice]} &>/dev/null
