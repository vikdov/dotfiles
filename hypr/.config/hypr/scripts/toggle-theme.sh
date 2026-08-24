#!/bin/bash

# Define current theme file path
THEME_FILE="$HOME/.cache/current_theme"

if [ "$(cat $THEME_FILE)" == "dark" ]; then
  # Switch to Light
  gsettings set org.gnome.desktop.interface color-scheme 'prefer-light'
  # Add commands here for your bar (e.g., Waybar) or terminal
  echo "light" >$THEME_FILE
else
  # Switch to Dark
  gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
  echo "dark" >$THEME_FILE
fi
