#!/usr/bin/env bash
# Prevent multiple instances
pgrep -x wofi && pkill -x wofi && exit 0

options=(
  "󰍁 Lock"
  "󰍃 Logout"
  "󰜉 Reboot"
  "󰤆 Shutdown"
)

choice=$(
  printf "%s\n" "${options[@]}" | wofi \
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

case "$choice" in
  "󰍁 Lock")     ~/.config/hypr/scripts/lock-screen.sh ;;
  "󰍃 Logout")   loginctl terminate-session "$XDG_SESSION_ID" ;;
  "󰜉 Reboot")   systemctl reboot ;;
  "󰤆 Shutdown") systemctl poweroff ;;
esac
