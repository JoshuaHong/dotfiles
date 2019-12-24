#!/bin/bash

# An i3blocks update output script.
# Requires an optional "$BLOCK_BUTTON" instance for mouse events.

# Listen for mouse events.
case "$BLOCK_BUTTON" in
  1) # On left click.
    updates=$(checkupdates 2>&1)
    if echo "$updates" | grep -q "ERROR"; then
      alacritty -e bash -c "echo \"Error: Try again.\" && sleep infinity"
    elif [[ -z "$updates" ]]; then
      alacritty -e bash -c "echo \"No updates.\" && sleep infinity"
    else
      alacritty -e bash -c "yay -Syu && nvim +PlugUpgrade +PlugUpdate +qall && \
          echo \"Done!\" && sleep infinity"
    fi
    ;;
  3) # On right click.
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
  # Output full text.
  echo "📥"
  # Output short text.
  echo "📥"
elif [[ -n "$updates" ]]; then
  # Output full text.
  echo "📥 $(echo "$updates" | wc -l)"
  # Output short text.
  echo "$updates" | wc -l
fi

exit 0
