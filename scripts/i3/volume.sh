#!/bin/bash

# An i3blocks volume output script

volume="$(amixer sget Master \
  | awk -F"[][]" '/dB/ {print substr($2, 1, length($2) -1)}')"
muted="$(amixer sget Master | grep "off")"

# Full text
if [[ -z "$muted" ]]; then
  if [[ "$volume" -le 33 ]]; then
    icon="🔈"
    echo "$icon $volume%"
  elif [[ "$volume" -le 66 ]]; then
    icon="🔉"
    echo "$icon $volume%"
  else
    icon="🔊"
    echo "$icon $volume%"
  fi
else
  icon="🔇"
  echo "$icon muted($volume%)"
fi

# Short text
echo "$volume%"

# Color
if [[ ! -z "$muted" ]]; then
  echo "#ffff00"
fi

# Notifications
bar="$(seq -s "─" $(($volume / 5 + 1)) | sed 's/[0-9]//g')"
dunstify -h string:x-canonical-private-synchronous:"volume" "$icon   $bar"

exit 0
