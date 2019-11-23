#!/bin/bash

# Takes a screenshot

# Usage
usage() {
  echo "Options:"
  echo "  -s: select portion of screen to capture"
}

# Define flags
s="false"

# Check for flags
while getopts "s" flag; do
  case "${flag}" in
    s)
      s="true"
      ;;
    *)
      echo "Error: Unexpected option"
      usage
      exit 1
      ;;
  esac
done

# Notifications
# Uses the same parameters as the dunstify command
# Click to kill script
notify() {
  dunstify -h string:x-canonical-private-synchronous:"screenshot" "$@"
}

# Capture screenshot
if [[ "$s" == "true" ]]; then
  scrot -s "$HOME/images/screenshots/%F::%T.png" \
    && notify "Screenshot Taken" "📸 $(date "+%F::%T.png")" \
    & notify "Screenshot" "📷 Drag mouse to capture"
else
  scrot "$HOME/images/screenshots/%F::%T.png" \
    && notify "Screenshot Taken" "📸 $(date "+%F::%T.png")"
fi
