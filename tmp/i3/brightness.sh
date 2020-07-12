#!/bin/bash

# An i3blocks brightness output script.

brightness="$(xbacklight -get | cut -d "." -f 1)"

# Output full text.
echo "💡 $brightness%"

# Output short text.
echo "$brightness%"

# Sends notifications.
bar="$(seq -s "─" "$(("$brightness" / 5 + 1))" | sed 's/[0-9]//g')"
dunstify -h string:x-canonical-private-synchronous:"brightness" "💡   $bar"

exit 0
