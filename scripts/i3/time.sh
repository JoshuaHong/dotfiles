#!/bin/sh

# An i3blocks time output script
# Takes in a $BLOCK_BUTTON instance for mouse events

# Notifications
# Uses the same parameters as the dunstify command
notify() {
  dunstify -t 1200 -h string:x-canonical-private-synchronous:"time" "$@"
}

# Full text
date "+%R"

# Short text
date "+%R"

case $BLOCK_BUTTON in
  1) # Left click
    for i in {1..3}; do
      notify "Time" "🕛 $(date +%T)"
      sleep 1
    done
    ;;
  3) # Right click
    for i in {1..60}; do
      notify "Time" "🕛 $(date +%T)"
      sleep 1
    done
    ;;
esac

exit 0
