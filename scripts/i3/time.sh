#!/bin/sh

# An i3blocks time output script
# Takes in a $BLOCK_BUTTON instance for mouse events

# Notifications
# Uses the same parameters as the dunstify command
# Click to kill script
notify() {
  if [ $(dunstify -t 975 -h string:x-canonical-private-synchronous:"time" \
    -A Y,yes "$@") -eq 2 ]; then
      pkill -KILL time.sh
  fi
}

# Converts miliseconds to days, hours, minutes, seconds, miliseconds
# Takes time in miliseconds and returns expanded time as formatted string
msConverter() {
  printf "%dd %dh %dm %ds %dms\n" $(($1/86400000)), $((($1/3600000)%24)), \
    $((($1/60000)%60)), $((($1/1000)%60)), $(($1%1000))
}

# Stopwatch notifications
# Uses the same parameters as the dunstify command
# Click to show elapsed time
notifyStopwatch() {
  if [ $(dunstify -t 50 -h string:x-canonical-private-synchronous:"time" \
    -A Y,yes "$@") -eq 2 ]; then
      dunstify -t 0 -h string:x-canonical-private-synchronous:"time" \
        "Time Elapsed" \
        "🕛 $(msConverter $((($(date +%s%N)-$begin+500000)/1000000)))"
      pkill -KILL time.sh
  fi
}

# Full text
date "+ %R"

# Short text
date "+ %R"

case $BLOCK_BUTTON in
  1) # Left click
    while [ true ]; do
      notify "Time" "🕛 $(date +%T)"
    done
    ;;
  3) # Right click
    begin=$(date +%s%N)
    while [ true ]; do
      # +500000 for rounding - num=num+den/2
      notifyStopwatch "Stopwatch" \
        "🕛 $(msConverter $((($(date +%s%N)-$begin+500000)/1000000)))"
    done
    ;;
esac

exit 0
