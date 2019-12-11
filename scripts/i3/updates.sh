#!/bin/bash

# An i3blocks update output script
# Takes in a $BLOCK_BUTTON instance for mouse events

# Notifications
notify() {
  dunstify -h string:x-canonical-private-synchronous:"updates" "$@"
}

updates=$(checkupdates 2>&1)
if echo "$updates" | grep -q "ERROR"; then
  echo "📥"
  echo "📥"
elif [[ ! -z "$updates" ]]; then
  echo "📥 $(echo "$updates" | wc -l)"
  echo "$updates" | wc -l
fi

# Mouse listener
case "$BLOCK_BUTTON" in
  1) # Left click
    alacritty -e bash -c "sudo pacman -Syu; echo "Done!"; sleep infinity"
    ;;
  3) # Right click
    alacritty -e bash -c "checkupdates; echo "Done!"; sleep infinity"
    ;;
esac

exit 0
