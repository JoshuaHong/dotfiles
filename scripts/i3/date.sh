#!/bin/bash

# An i3blocks date output script.
# Requires an optional "$BLOCK_BUTTON" instance for mouse events.

# Sends notifications.
# Requires the same parameters "$@" as the dunstify command.
notify() {
  dunstify "$@"
}

# Output full text.
echo "📅 $(date "+%a %b %d")"

# Output short text.
date "+%a %b %d"

# Listen for mouse events.
case "$BLOCK_BUTTON" in
  1) # Left click.
    notify -t 0 "$(cal)"
    ;;
  3) # Right click.
    for i in {1..12}; do
      notify -t 5000 "$(cal $(date "+%m %Y" -d "$(date +%F) + $i month"))"
    done
    ;;
esac

exit 0
