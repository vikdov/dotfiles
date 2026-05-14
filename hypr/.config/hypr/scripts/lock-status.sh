#!/usr/bin/env bash
BAT=$(cat /sys/class/power_supply/BAT1/capacity)
STATUS=$(cat /sys/class/power_supply/BAT1/status)
if [ "$STATUS" = "Charging" ]; then   ICON="󰂄"
elif [ "$BAT" -gt 80 ]; then          ICON="󰁹"
elif [ "$BAT" -gt 60 ]; then          ICON="󰂀"
elif [ "$BAT" -gt 40 ]; then          ICON="󰁾"
elif [ "$BAT" -gt 20 ]; then          ICON="󰁻"
else                                   ICON="󰁺"
fi
echo " $USER   $ICON ${BAT}%"
