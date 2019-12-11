#!/bin/bash

# An i3blocks update output script
# Takes in a $BLOCK_BUTTON instance for mouse events

updates=$(checkupdates 2>&1)
if echo "$updates" | grep -q "ERROR"; then
  # Full text
  echo "📥"
  # Short text
  echo "📥"
elif [[ ! -z "$updates" ]]; then
  # Full text
  echo "📥 $(echo "$updates" | wc -l)"
  # Short text
  echo "$updates" | wc -l
fi

# Mouse listener
case "$BLOCK_BUTTON" in
  1) # Left click
    alacritty -e bash -c "sudo pacman -Syu && echo \"Done!\" \
        && pkill -SIGRTMIN+12 i3blocks && sleep infinity"
    ;;
  3) # Right click
    alacritty -e bash -c "checkupdates && sleep infinity"
    ;;
esac

exit 0
