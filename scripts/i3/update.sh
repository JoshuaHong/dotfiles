#!/bin/bash

# An i3blocks update output script.
# Requires an optional "$BLOCK_BUTTON" instance for mouse events.

# Performs updates based on checkupdates output.
# Requires a block button value as "$1".
i3BlocksUpdate() {
  echo "Fetching updates..."
  updates="$(checkupdates 2>&1)"

  if echo "$updates" | grep -q "ERROR"; then
    echo "Error: Could not fetch updates."
  elif [[ -z "$updates" ]]; then
    echo "No new updates."
  else
    if [[ "$1" == "1" ]]; then
      if yay -Syu && nvim +PlugUpgrade +PlugUpdate +qall; then
        echo "Done!"
      else
        echo "Error: Update failed."
      fi
    elif [[ "$1" == "3" ]]; then
      echo "Updates:"
      echo "$updates"
    fi
  fi
  sleep infinity
}

# Listen for mouse events.
case "$BLOCK_BUTTON" in
  1) # On left click.
    export -f i3BlocksUpdate
    bash -ic '$TERMINAL -e bash -c "i3BlocksUpdate \"1\""'
    ;;
  3) # On right click.
    export -f i3BlocksUpdate
    bash -ic '$TERMINAL -e bash -c "i3BlocksUpdate \"3\""'
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
