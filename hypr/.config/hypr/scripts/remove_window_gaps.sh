#!/bin/bash

STATE_FILE="/tmp/hypr_gaps_toggle_state"

NORMAL_IN=1
NORMAL_OUT=10
NORMAL_BORDER=2
NORMAL_ROUNDING=10

# Check current toggle state
if [ -f "$STATE_FILE" ]; then
  STATE=$(cat "$STATE_FILE")
else
  STATE="normal"
fi

if [ "$STATE" = "normal" ]; then
  hyprctl eval "hl.config({ general = { gaps_in = 0, gaps_out = 0, border_size = 0 }, decoration = { rounding = 0 } })"
  echo "fullscreen" >"$STATE_FILE"
else
  hyprctl eval "hl.config({ general = { gaps_in = $NORMAL_IN, gaps_out = $NORMAL_OUT, border_size = $NORMAL_BORDER }, decoration = { rounding = $NORMAL_ROUNDING } })"
  echo "normal" >"$STATE_FILE"
fi
