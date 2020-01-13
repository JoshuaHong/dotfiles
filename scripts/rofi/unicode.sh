#!/bin/bash

# A rofi list of unicode characters to copy to the clipboard.

# Sends notifications.
# Requires the same parameters "$@" as the dunstify command.
notify() {
  dunstify -h string:x-canonical-private-synchronous:"unicode" "$@"
}

unicode="$(grep -v "//" "$HOME/scripts/etc/unicode.txt" \
    | rofi -dmenu -i -p "Unicode" | awk '{print $1}')"

if [[ -n "$unicode" ]]; then
  echo -e "$unicode" | tr -d "\n" | xclip -selection clipboard \
      && notify "Unicode" "$unicode Copied to clipboard."
fi
