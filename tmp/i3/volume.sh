#!/bin/bash

# An i3blocks volume output script.

volume="$(pamixer --get-volume)"
muted="$(pamixer --get-mute)"

# Output full text.
if [[ "$muted" == "false" ]]; then
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
elif [[ "$muted" == "true" ]]; then
  icon="🔇"
  echo "$icon muted($volume%)"
fi

# Output short text
echo "$volume%"

# Output color on muted.
if [[ "$muted" == "true" ]]; then
  echo "#ffff00"
fi

# Sends notifications.
bar="$(seq -s "─" "$(("$volume" / 5 + 1))" | sed 's/[0-9]//g')"
dunstify -h string:x-canonical-private-synchronous:"volume" "$icon   $bar"

exit 0
