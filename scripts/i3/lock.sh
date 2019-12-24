#!/bin/bash

# Locks the screen using a custom lockscreen.

# Outputs the usage.
usage() {
  echo "Options:"
  echo "  -f: force locking over videos"
  echo "  -t: transparent background"
}

# Define flags.
f="false"
t="false"

# Check for flags.
while getopts "ft" flag; do
  case "${flag}" in
    f)
      f="true"
      ;;
    t)
      t="true"
      ;;
    *)
      echoerr "Error: Unexpected option"
      usage
      exit 1
      ;;
  esac
done

# Outputs to standard error.
# Requires a message "$@" to print.
echoerr() {
  echo "$@" 1>&2
}

# Suspends if inactive on lockscreen.
checklock() {
  sleep 300

  local i3lockrunning
  i3lockrunning="$(pgrep --exact --count i3lock)"
  if [[ "$i3lockrunning" -gt "0" ]]; then
    systemctl suspend && checklock
  fi
}

# Locks the screen.
lock() {
  local icon="$HOME/images/icons/lock.png"
  local tmpbg="/tmp/lockscreen.png"

  if [[ "$t" == "true" ]]; then
    # Take a screenshot.
    scrot "$tmpbg" -o
    # Blur the screenshot by resizing and scaling back up.
    convert "$tmpbg" -filter Gaussian -thumbnail 20% -sample 500% "$tmpbg"
  else
    # Use default lockscreen.
    cp "$HOME/images/wallpapers/lockscreen.png" "/tmp/"
  fi

  # Overlay the icon onto the screenshot.
  convert "$tmpbg" "$icon" -gravity Center -geometry +0-5 -composite "$tmpbg"

  # Lock the screen and checklock - unmute and kill checklock on unlock.
  checklock & i3lock --image="$tmpbg" --ignore-empty-password --nofork \
      && amixer set Master,0 unmute && pkill -15 lock.sh
}

# Don't lock the screen if a video is playing, unless the force option is set.
drivers="/proc/asound/card*/pcm*/sub*/status"
if [[ "$f" == "true" ]] || ! cat $drivers | grep -q "state: RUNNING"; then
  # Mute the audio.
  amixer set Master,0 mute

  # Lock the screen.
  lock
fi
