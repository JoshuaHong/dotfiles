#!/bin/bash

# A timer script to send an alert at a specified time.
# Requires a time in the following format: xx:xx:xx or xxh xxm xxs.
# For example: ./timer 5:24:30 or ./timer 5h 24m 30s.

# Outputs the usage.
usage() {
  echo "To specify a time: ./timer xx:xx:xx or ./timer xxh xxm xxs."
  echo "Press any key to pause or resume."
  echo "Options:"
  echo "  --help: Shows options."
  echo "  -a|--alert: Hides alert notifications."
  echo "  -h|--hidden: Hides time notifications."
  echo "  -n|--name: Sets the name of the timer."
  echo "  -q|--quiet: Suppresses standard output."
  echo "  -s|--stopwatch: Uses the stopwatch."
  echo "  -t|--time: Alerts at the specified time."
}

# Define flags.
a="false"
h="false"
n=""
q="false"
s="false"
t="false"

# Check for flags.
while getopts "ahn:qst-:" flags; do
  case "${flags}" in
    -)
      case "${OPTARG}" in
        help)
          usage
          exit 0
          ;;
        alert)
          a="true"
          ;;
        hidden)
          h="true"
          ;;
        name)
          n="${!OPTIND} "
          OPTIND="$(( OPTIND + 1 ))"
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
    a)
      a="true"
      ;;
    h)
      h="true"
      ;;
    n)
      n="$OPTARG "
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

# Outputs to standard error.
# Requires a message "$@" to print.
echoerr() {
  echo "$@" 1>&2
}

# Stops processes on interrupt signal and sends a stopped notification.
# Requires the same parameters "$@" as the dunstify command.
stop() {
  if [[ -f "/tmp/timerIsPaused$$.txt" ]]; then
    rm -f "/tmp/timerIsPaused$$.txt"
  fi
  if [[ "$h" == "false" ]]; then
    dunstify -h string:x-canonical-private-synchronous:"timer$$" "$@"
  fi
  exit 0
}

# Sends timer notifications.
# Requires the same parameters "$@" as the dunstify command.
notify() {
  dunstify -h string:x-canonical-private-synchronous:"timer$$" "$@"
}

# Outputs the time.
# Requires the message to be printed.
print() {
  echo -n "$@"
  echo -ne "\r"
}

# Converts milliseconds to hours, minutes, seconds, and milliseconds.
# Requires a time in milliseconds.
# Returns the expanded time as a formatted string.
msConverter() {
  printf "%02dh %02dm %02ds %03dms\n" "$((("$1"/3600000)%24))" \
      "$((("$1"/60000)%60))" "$((("$1"/1000)%60))" "$(("$1"%1000))"
}

# Converts seconds to hours, minutes, and seconds.
# Requires a time in seconds.
# Returns the expanded time as formatted string.
secConverter() {
  printf "%02dh %02dm %02ds\n" "$(("$1"/3600))" "$((("$1"%3600)/60))" \
      "$(("$1"%60))"
}

# Starts the stopwatch.
stopwatch() {
  local start
  local timePaused
  local pauseStart
  local pauseEnd
  local end
  timePaused=0
  start="$(date "+%s%N")"

  # Loop until interrupted.
  while true; do
    if [[ -f "/tmp/timerIsPaused$$.txt" ]]; then
      pauseStart="$(date "+%s%N")"
      pauseEnd="$pauseStart"

      # Use +500000 for rounding.
      end="$(msConverter \
          "$(((("$pauseStart"-"$start")-"$timePaused"+500000)/1000000))")"

      # Pause the time.
      if [[ "$(< "/tmp/timerIsPaused$$.txt")"  == "true" ]]; then
        if [[ "$h" == "false" ]]; then
          notify -t 0 "${n}Stopwatch (Paused)" "🕛 $end"
        fi
        if [[ "$q" == "false" ]]; then
          print "${n}Stopwatch (Paused): $end"
        fi
        while [[ "$(< "/tmp/timerIsPaused$$.txt")"  == "true" ]]; do
          pauseEnd="$(date "+%s%N")"
        done
        ((timePaused+=("$pauseEnd"-"$pauseStart")))
      fi
    else
      echoerr "Error: timerIsPaused$$.txt not found."
      exit 1
    fi

    # Use +500000 for rounding.
    end="$(msConverter \
        "$(((("$(date "+%s%N")"-"$start")-"$timePaused"+500000)/1000000))")"

    # Output the time.
    if [[ "$h" == "false" ]]; then
      notify "${n}Stopwatch" "🕛 $end"
    fi
    if [[ "$q" == "false" ]]; then
      print "${n}Time elapsed      : $end"
    fi

    # Trap the interrupt signal.
    trap "stop \"${n}Stopwatch (Stopped)\" \"🕛 $end\"" SIGINT
  done
}

# Starts the timer.
timer() {
  local start
  local end
  local remaining
  local pauseStart
  local pauseEnd
  local isStartPrinted
  isStartPrinted="false"
  start="$(date "+%s%N")"

  # Calculate the end time.
  if [[ "$t" == "true" ]]; then
    end="$((("$hours"*3600+"$minutes"*60+"$seconds") \
        -("$(date "+%H")"*3600+"$(date "+%M")"*60+"$(date "+%S")")))"
    if [[ "$end" -lt 0 ]]; then
      end="$(("$end"+86400))"
    fi
    end="$(date -d "+$end seconds" "+%s%N")"
  else
    end="$(date -d "+$hours hours $minutes minutes $seconds seconds" "+%s%N")"
  fi
  remaining="$(secConverter "$(("$end"-"$start"))")"

  # Loop until timer expires or interrupted.
  while [[ "$start" -le "$end" ]]; do
    if [[ -f "/tmp/timerIsPaused$$.txt" ]]; then
      pauseStart="$(date "+%s%N")"
      pauseEnd="$pauseStart"

      # Pause the time.
      if [[ "$(< "/tmp/timerIsPaused$$.txt")"  == "true" ]]; then
        if [[ "$h" == "false" ]]; then
          notify -t 0 "${n}Timer (Paused)" "⏳ $remaining"
        fi
        if [[ "$q" == "false" ]]; then
          print "${n}Timer (Paused): $remaining"
        fi
        while [[ "$(< "/tmp/timerIsPaused$$.txt")"  == "true" ]]; do
          pauseEnd="$(date "+%s%N")"
          # Use +500000000 for rounding.
          remaining=$(secConverter "$((("$end"-"$start"+500000000) \
              /1000000000))")
        done
        ((end+=("$pauseEnd"-"$pauseStart")))
      fi
    else
      echoerr "Error: timerIsPaused$$.txt not found."
      exit 1
    fi

    # Output the time.
    if [[ "$start" -le "$(date -d "+-1 second" "+%s%N")" \
        || "$isStartPrinted" == "false" ]]; then
      isStartPrinted="true"
      start="$(date "+%s%N")"
      # Use +500000000 for rounding.
      remaining=$(secConverter "$((("$end"-"$start"+500000000)/1000000000))")
      if [[ "$h" == "false" ]]; then
        notify "${n}Timer" "⏳ $remaining"
      fi
      if [[ "$q" == "false" ]]; then
        print "${n}Time remaining: $remaining"
      fi
    fi

    # Trap the interrupt signal.
    trap "stop \"${n}Timer (Stopped)\" \"⌛ $remaining\"" SIGINT
  done

  # Output the final message on completion.
  if [[ "$q" == "false" ]]; then
    echo -n "${n}Timer complete"
    echo -ne "\r"
  fi
  if [[ "$a" == "false" ]]; then
    notify "${n}Timer" "⌛ Complete" -u critical
  elif [[ "$h" == "false" ]]; then
    notify "${n}Timer" "⌛ Complete"
  fi

  # Clean up and exit.
  if [[ -f "/tmp/timerIsPaused$$.txt" ]]; then
    rm -f "/tmp/timerIsPaused$$.txt"
  fi
  echo ""
  kill -15 $$
  exit 0
}

# Pauses or resumes the timer script.
# Modifies /tmp/timerIsPaused$$.txt, a text file containing the script's
# paused or resumed state.
pauseResume() {
  echo "false" > "/tmp/timerIsPaused$$.txt"

  while true; do
    read -n 1 -s -r
    if [[ "$(< "/tmp/timerIsPaused$$.txt")"  == "true" ]]; then
      echo "false" > "/tmp/timerIsPaused$$.txt"
    else
      echo "true" > "/tmp/timerIsPaused$$.txt"
    fi
  done
}

# Start the stopwatch if set.
if [[ "$s" == "true" ]]; then
  if [[ "$#" -eq 0 ]]; then
    stopwatch &
    pauseResume
    exit 0
  else
    echoerr "Error: No arguments needed for the stopwatch option."
    exit 1
  fi
fi

hours=0
minutes=0
seconds=0

# Parse arguments and check for valid input.
if [[ "$1" =~ ^[0-9]+:[0-5]?[0-9]:[0-5]?[0-9]$ ]]; then
  hours="$(echo "$1" | cut -d ":" -f1)"
  minutes="$(echo "$1" | cut -d ":" -f2)"
  seconds="$(echo "$1" | cut -d ":" -f3)"
elif [[ "$*" =~ \
    ^([0-9]*h)?[[:space:]]*([0-9]*m)?[[:space:]]*(([0-9]*s)?)$ ]]; then
  remainder="$*"
  if [[ "$remainder" == *h* ]]; then
    hours="${remainder%%h*}"
    remainder="${remainder#*h}"
  fi
  if [[ "$remainder" == *m* ]]; then
    minutes="${remainder%%m*}"
    remainder="${remainder#*m}"
  fi
  if [[ "$remainder" == *s ]]; then
    seconds="${remainder%%s*}"
  fi
else
  echoerr "Error: Invalid time format."
  exit 1
fi

# Check for a valid alert time.
if [[ "$t" == "true" \
    && ("$hours" -ge 24 || "$minutes" -ge 60 || "$seconds" -ge 60) ]]; then
  echoerr "Error: The alert time must be in the range 00:00:00 - 23:59:59."
  exit 1
fi

# Start the timer.
if [[ "$t" == "true" \
    || ("$hours" -ne 0 || "$minutes" -ne 0 || "$seconds" -ne 0) ]]; then
  timer &
  pauseResume
  exit 0
else
  if [[ "$#" -gt 0 ]]; then
    echoerr "Error: Cannot set the timer for 0 seconds."
  else
    usage
  fi
  exit 1
fi
