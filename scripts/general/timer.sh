#!/bin/bash

# A timer script to send an alert after a specified time
# Takes a time in the following format: xx:xx:xx or xxh xxm xxs
# For example: ./timer 5:24:30 or ./timer 5h 24m 30s

# Usage
usage() {
  echo "To specify a time: ./timer xx:xx:xx"
  echo "Options:"
  echo "  -h|--help: show options"
  echo "  -q|--quiet: no notifications"
  echo "  -s|--stopwatch: stopwatch"
  echo "  -t|--time: alert at the specified time"
}

# Define flags
q="false"
s="false"
t="false"

# Check for flags
while getopts "hqst-:" flags; do
  case "${flags}" in
    -)
      case "${OPTARG}" in
        help)
          usage
          exit 0
          ;;
        quiet)
          q="true"
          ;;
        stopwatch)
          s="true"
          ;;
        time)
          t="true"
          ;;
        *)
          usage
          exit 1
          ;;
      esac
      ;;
    h)
      usage
      exit 0
      ;;
    q)
      q="true"
      ;;
    s)
      s="true"
      ;;
    t)
      t="true"
      ;;
    *)
      usage
      exit 1
      ;;
  esac
done
shift "$((OPTIND-1))"

# Stops processes on interrupt signal
stop() {
  echo "$@"
  exit 0
}

# Notifications
# Uses the same parameters as the dunstify command
notify() {
  if [[ "$(dunstify -t 975 -h string:x-canonical-private-synchronous:"timer" \
    -A Y,yes "$@")" == "2" ]]; then
      dunstify -h string:x-canonical-private-synchronous:"timer" \
        "Timer" "⌛ Timer Stopped"
      stop "Timer Stopped"
  fi
}

# Stopwatch notifications
# Uses the same parameters as the dunstify command
# Click to show elapsed time
notifyStopwatch() {
  if [[ "$(dunstify -t 50 \
    -h string:x-canonical-private-synchronous:"stopwatch" -A Y,yes "$@")" \
    == "2" ]]; then
      dunstify -t 0 -h string:x-canonical-private-synchronous:"stopwatch" \
        "Time Elapsed" "🕛 $end"
      stop $'Time Elapsed:\n'"$end"
  fi
}

# Converts miliseconds to days, hours, minutes, seconds, miliseconds
# Takes time in miliseconds and returns expanded time as formatted string
msConverter() {
  printf "%02dd %02dh %02dm %02ds %03dms\n" "$(("$1"/86400000))" \
    "$((("$1"/3600000)%24))" "$((("$1"/60000)%60))" "$((("$1"/1000)%60))" \
    "$(("$1"%1000))"
}

# Converts seconds to hours, minutes, seconds
# Takes time in seconds and returns expanded time as formatted string
secConverter() {
  printf "%02dh %02dm %02ds\n" "$(("$1"/3600))" "$((("$1"%3600)/60))" \
    "$(("$1"%60))"
}

# Start the stopwatch
stopwatch() {
  local start="$(date +%s%N)"
  while true; do
    # +500000 for rounding - num=num+den/2
    local end="$(msConverter "$((("$(date +%s%N)"-"$start"+500000)/1000000))")"
    if [[ "$q" == "false" ]]; then
      notifyStopwatch "Stopwatch" "🕛 $end"
    fi
    trap "stop Time Elapsed:$'\n'$end" SIGINT
  done
}

# Start the timer
timer() {
  local start="$(date "+%s")"
  if [[ "$t" == "true" ]]; then
    local end="$((("$hours"*3600+"$minutes"*60+"$seconds") \
      -("$(date "+%H")"*3600+"$(date "+%M")"*60+"$(date "+%S")")))"
    if [[ "$end" -lt 0 ]]; then
      local end="$(("$end"+86400))"
    fi
    local end="$(("$end"+"$(date "+%s")"))"
  else
    local end="$(date -d "+$hours hours $minutes minutes $seconds seconds" \
      "+%s")"
  fi

  while [[ "$start" != "$end" ]]; do
    if [[ "$start" == "$(date -d "+-1second" "+%s")" ]]; then
      start="$(date "+%s")"
      if [[ "$q" == "false" ]]; then
        notify "Timer" "⏳ $(secConverter "$(("$end" - "$start"))")"
      fi
    fi
    trap "stop Timer Stopped" SIGINT
  done
  notify -u critical -t 0 "Timer" "⌛ Complete"
}

# Parse arguments and check valid input
hours=0
minutes=0
seconds=0

if [[ "$1" =~ ^[0-9]+:[0-5]?[0-9]:[0-5]?[0-9]$ ]]; then
  hours="$(echo "$1" | cut -d ":" -f1)"
  minutes="$(echo "$1" | cut -d ":" -f2)"
  seconds="$(echo "$1" | cut -d ":" -f3)"
elif [[ "$@" =~ \
  ^([0-9]*h)?[[:space:]]*([0-5]?[0-9]m)?[[:space:]]*(([0-5]?[0-9]s)?)$ ]]; then
    for time in "$@"; do
      if [[ "$time" == *h ]]; then
        hours="${time::-1}"
      elif [[ "$time" == *m ]]; then
        minutes="${time::-1}"
      elif [[ "$time" == *s ]]; then
        seconds="${time::-1}"
      fi
    done
elif [[ "$#" -ne 0 && "$s" = "false" ]]; then
  echo "Invalid time"
  exit 1
fi

# Check valid alert time
if [[ "$t" == "true" && hours -ge 24 ]]; then
  echo "Time must be in the range 00:00:00 - 23::59:59"
  exit 1
fi

# Start timer
if [[ "$#" -ne 0 && "$t" == "true" \
  || ("$hours" -ne 0 || "$minutes" -ne 0 || "$seconds" -ne 0) ]]; then
    timer &
elif [[ "$#" -ne 0 || "$s" == "false" || "$t" == "true" ]]; then
  echo "Cannot set timer for 0 seconds"
  exit 1
fi

# Start stopwatch
if [[ "$s" == "true" ]]; then
  stopwatch &
fi

wait
