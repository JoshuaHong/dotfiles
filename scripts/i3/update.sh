#!/bin/bash

# An i3blocks update output script
# Takes in a $BLOCK_BUTTON instance for mouse events

# Mouse listener
case "$BLOCK_BUTTON" in
  1) # Left click
    alacritty -e bash -c "yay -Syu && echo \"Done!\" && sleep infinity"
    ;;
  3) # Right click
    alacritty -e bash -c "echo \"Updates:\" && checkupdates && sleep infinity"
    ;;
esac

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

exit 0
