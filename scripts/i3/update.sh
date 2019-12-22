#!/bin/bash

# An i3blocks update output script
# Takes in a $BLOCK_BUTTON instance for mouse events

# Mouse listener
case "$BLOCK_BUTTON" in
  1) # Left click
    alacritty -e bash -c "yay -Syu && nvim +PlugUpgrade +PlugUpdate +qall && \
        echo \"Done!\" && sleep infinity"
    ;;
  3) # Right click
    updates=$(checkupdates 2>&1)
    if echo "$updates" | grep -q "ERROR"; then
      alacritty -e bash -c "echo \"Error: Try again.\" && sleep infinity"
    elif [[ -z "$updates" ]]; then
      alacritty -e bash -c "echo \"No updates.\" && sleep infinity"
    else
      alacritty -e bash -c "echo \"Updates:\" && checkupdates && sleep infinity"
    fi
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
