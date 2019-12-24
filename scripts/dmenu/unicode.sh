#!/bin/bash

# A dmenu list of unicode characters to copy to the clipboard.

# Sends notifications.
# Requires the same parameters "$@" as the dunstify command.
notify() {
  dunstify -h string:x-canonical-private-synchronous:"unicode" "$@"
}

unicode="$(grep -v "//" "$HOME/scripts/etc/unicode.txt" \
    | dmenu -i -l 20 -fn "Noto Fonts -14" | awk '{print $1}')"

if [[ -n "$unicode" ]]; then
  echo -e "$unicode" | tr -d "\n" | xclip -selection clipboard \
      && notify "Unicode" "$unicode Copied to clipboard."
fi
