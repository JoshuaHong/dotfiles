#!/bin/bash

# An i3blocks time output script
# Takes in a $BLOCK_BUTTON instance for mouse events

# Stops processes on interrupt signal
stop() {
  exit 0
}

# Notifications
# Uses the same parameters as the dunstify command
# Click to kill script
notify() {
  if [ $(dunstify -t 975 -h string:x-canonical-private-synchronous:"time" \
    -A Y,yes "$@") -eq 2 ]; then
      stop
  fi
}

# Converts miliseconds to days, hours, minutes, seconds, miliseconds
# Takes time in miliseconds and returns expanded time as formatted string
msConverter() {
  printf "%02dd %02dh %02dm %02ds %03dms\n" $(($1/86400000)) \
    $((($1/3600000)%24)) $((($1/60000)%60)) $((($1/1000)%60)) $(($1%1000))
}

# Stopwatch notifications
# Uses the same parameters as the dunstify command
# Click to show elapsed time
notifyStopwatch() {
  if [[ "$(dunstify -t 50 \
    -h string:x-canonical-private-synchronous:"stopwatch" -A Y,yes "$@")" \
    = "2" ]]; then
      dunstify -t 0 -h string:x-canonical-private-synchronous:"stopwatch" \
        "Time Elapsed" "🕛 $end"
      stop
  fi
}

# Full text
echo "🕛 $(date "+%R")"

# Short text
date "+%R"

case $BLOCK_BUTTON in
  1) # Left click
    while [ true ]; do
      notify "Time" "🕛 $(date +%T)"
    done
    ;;
  3) # Right click
    start="$(date +%s%N)"
    while true; do
      # +500000 for rounding - num=num+den/2
      end="$(msConverter $((($(date +%s%N)-$start+500000)/1000000)))"
      notifyStopwatch "Stopwatch" "🕛 $end"
    done
    ;;
esac

exit 0
