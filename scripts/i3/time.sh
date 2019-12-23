#!/bin/bash

# An i3blocks time output script
# Takes in a $BLOCK_BUTTON instance for mouse events

# Stops processes on interrupt signal
stop() {
  exit 0
}

# Notifications
# Uses the same parameters as the dunstify command
# Click to kill script
notify() {
  if [ "$(dunstify -t 975 -h string:x-canonical-private-synchronous:"time" \
      -A Y,yes "$@")" -eq 2 ]; then
    stop
  fi
}

# Full text
echo "🕛 $(date "+%R")"

# Short text
date "+%R"

case "$BLOCK_BUTTON" in
  1) # Left click
    while true; do
      notify "Time" "🕛 $(date +%T)"
    done
    ;;
  3) # Right click
    for i in {0..4}; do
      notify "Time" "🕛 $(date +%T)"
    done
    ;;
esac

exit 0
