#!/bin/bash

CONFIG="$HOME/.config/hypr/hyprland.conf"
STATE_FILE="/tmp/hypr_gaps_toggle_state"

# Extract default values from config
NORMAL_IN=$(grep -E "^\s*gaps_in\s*=" "$CONFIG" | head -n 1 | awk -F '=' '{print $2}' | tr -d ' ')
NORMAL_OUT=$(grep -E "^\s*gaps_out\s*=" "$CONFIG" | head -n 1 | awk -F '=' '{print $2}' | tr -d ' ')
NORMAL_BORDER=$(grep -E "^\s*border_size\s*=" "$CONFIG" | head -n 1 | awk -F '=' '{print $2}' | tr -d ' ')
NORMAL_ROUNDING=$(grep -E "^\s*rounding\s*=" "$CONFIG" | head -n 1 | awk -F '=' '{print $2}' | tr -d ' ')

# Set defaults if missing from config
NORMAL_BORDER=${NORMAL_BORDER:-2}
NORMAL_ROUNDING=${NORMAL_ROUNDING:-8}

# Check current toggle state
if [ -f "$STATE_FILE" ]; then
  STATE=$(cat "$STATE_FILE")
else
  STATE="normal"
fi

if [ "$STATE" = "normal" ]; then
  # Go pseudo-fullscreen
  hyprctl keyword general:gaps_in 0
  hyprctl keyword general:gaps_out 0
  hyprctl keyword general:border_size 0
  hyprctl keyword decoration:rounding 0
  echo "fullscreen" >"$STATE_FILE"
else
  # Restore original values
  hyprctl keyword general:gaps_in "$NORMAL_IN"
  hyprctl keyword general:gaps_out "$NORMAL_OUT"
  hyprctl keyword general:border_size "$NORMAL_BORDER"
  hyprctl keyword decoration:rounding "$NORMAL_ROUNDING"
  echo "normal" >"$STATE_FILE"
fi
