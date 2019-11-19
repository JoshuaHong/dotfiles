#!/bin/sh

# An i3blocks time output script
# Takes in a $BLOCK_BUTTON instance for mouse events

# Notifications
# Uses the same parameters as the dunstify command
notify() {
  if [ $(dunstify -t 980 -h string:x-canonical-private-synchronous:"time" -A Y,yes "$@") -eq 2 ]; then
    pkill -KILL time.sh
  fi
}

# Full text
date "+%R"

# Short text
date "+%R"

case $BLOCK_BUTTON in
  1) # Left click
    end=$((SECONDS+3))
    while [ $SECONDS -lt $end ]; do
      notify "Time" "🕛 $(date +%T)"
    done
    ;;
  3) # Right click
    end=$((SECONDS+60))
    while [ $SECONDS -lt $end ]; do
      notify "Time" "🕛 $(date +%T)"
    done
    ;;
esac

exit 0
