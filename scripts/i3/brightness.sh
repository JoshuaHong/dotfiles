#!/bin/bash

# An i3blocks brightness output script

brightness="$(xbacklight -get | cut -d "." -f 1)"

# Full text
echo "💡 $brightness%"

# Short text
echo "$brightness%"

# Notifications
bar="$(seq -s "─" $(($brightness / 5 + 1)) | sed 's/[0-9]//g')"
dunstify -h string:x-canonical-private-synchronous:"brightness" "💡   $bar"

exit 0
