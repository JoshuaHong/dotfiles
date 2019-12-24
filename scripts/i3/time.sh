#!/bin/bash

# An i3blocks time output script.
# Requires an optional "$BLOCK_BUTTON" instance for mouse events.

# Stops processes on interrupt signal.
stop() {
  exit 0
}

# Sends notifications.
# Requires the same parameters "$@" as the dunstify command.
# Click to kill the script.
notify() {
  if [ "$(dunstify -t 975 -h string:x-canonical-private-synchronous:"time" \
      -A Y,yes "$@")" -eq 2 ]; then
    stop
  fi
}

# Output full text.
echo "🕛 $(date "+%R")"

# Output short text.
date "+%R"

# Listen for mouse events.
case "$BLOCK_BUTTON" in
  1) # On left click.
    while true; do
      notify "Time" "🕛 $(date +%T)"
    done
    ;;
  3) # On right click.
    for i in {0..4}; do
      notify "Time" "🕛 $(date +%T)"
    done
    ;;
esac

exit 0
