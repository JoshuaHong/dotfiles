#!/bin/bash

# An i3blocks date output script
# Takes in a $BLOCK_BUTTON instance for mouse events

# Notifications
# Uses the same parameters as the dunstify command
notify() {
  dunstify "$@"
}

# Full text
echo "📅 $(date "+%a %b %d")"

# Short text
date "+%a %b %d"

# Mouse listener
case $BLOCK_BUTTON in
  1) # Left click
    notify -t 0 "$(cal)"
    ;;
  3) # Right click
    for i in {1..12}; do
      notify "$(cal $(date "+%m %Y" -d "$(date +%F) + $i month"))"
    done
    ;;
esac

exit 0
