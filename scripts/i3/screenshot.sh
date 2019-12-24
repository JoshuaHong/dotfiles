#!/bin/bash

# Takes a screenshot.

# Outputs the usage.
usage() {
  echo "Options:"
  echo "  -s: select portion of screen to capture"
}

# Define flags.
s="false"

# Check for flags.
while getopts "s" flag; do
  case "${flag}" in
    s)
      s="true"
      ;;
    *)
      echoerr "Error: Unexpected option"
      usage
      exit 1
      ;;
  esac
done

# Outputs to standard error.
# Requires a message "$@" to print.
echoerr() {
  echo "$@" 1>&2
}

# Sends notifications.
# Requires the same parameters "$@" as the dunstify command.
notify() {
  dunstify -h string:x-canonical-private-synchronous:"screenshot" "$@"
}

# Capture a screenshot.
if [[ "$s" == "true" ]]; then
  scrot -s "$HOME/images/screenshots/%F::%T.png" \
      && notify "Screenshot Taken" "📸 $(date "+%F::%T.png")" \
      & notify "Screenshot" "📷 Drag mouse to capture"
else
  scrot "$HOME/images/screenshots/%F::%T.png" \
      && notify "Screenshot Taken" "📸 $(date "+%F::%T.png")"
fi

exit 0
