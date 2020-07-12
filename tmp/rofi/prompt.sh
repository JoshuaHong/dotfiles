#!/bin/bash

# Gives a rofi prompt "$1" to perform command "$2".
# For example:
# ./prompt "Are you sure you want to exit i3?" "i3-msg exit".

if [[ "$(echo -e "No\nYes" | rofi -dmenu -i -p "$1")" == "Yes" ]]; then
  $2
fi
