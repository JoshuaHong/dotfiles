#!/bin/bash

# Locks the sceen using a custom lockscreen

# Usage
usage() {
  echo "Options:"
  echo "  -f: force locking over videos"
  echo "  -t: transparent background"
}

# Define flags
f="false"
t="false"

# Check for flags
while getopts "ft" flag; do
  case "${flag}" in
    f)
      f="true"
      ;;
    t)
      t="true"
      ;;
    *)
      echo "Error: Unexpected option"
      usage
      exit 1
      ;;
  esac
done

# Suspend if inactive on lockscreen
checklock() {
  sleep 300

  local i3lockrunning="$(pgrep --exact --count i3lock)"
  if [[ "$i3lockrunning" -gt "0" ]]; then
    systemctl suspend && checklock
  fi
}

# Lock screen
lock() {
  local icon="$HOME/images/icons/lock.png"
  local tmpbg="/tmp/lockscreen.png"

  # If transparent flag is used
  if [[ "$t" == "true" ]]; then
    # Take a screenshot
    scrot "$tmpbg" -o
    # Blur the screenshot by resizing and scaling back up
    convert "$tmpbg" -filter Gaussian -thumbnail 20% -sample 500% "$tmpbg"
  else
    # Use default lockscreen
    cp "$HOME/images/wallpapers/lockscreen.png" "/tmp/"
  fi

  # Overlay the icon onto the screenshot
  convert "$tmpbg" "$icon" -gravity Center -geometry +0-5 -composite "$tmpbg"

  # Lock the screen and checklock - unmute and kill checklock on unlock
  checklock & i3lock --image="$tmpbg" --ignore-empty-password --nofork \
    && amixer set Master,0 unmute && pkill -SIGTERM lock.sh
}

# Don't lock screen if video is playing unless force enabled
drivers="/proc/asound/card*/pcm*/sub*/status"
if [[ "$f" == "true" ]] || ! cat $drivers | grep -q "state: RUNNING"; then
  # Mute audio
  amixer set Master,0 mute

  # Lock
  lock
fi
