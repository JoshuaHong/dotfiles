#!/bin/bash

# Example notifier script -- lowers screen brightness, then waits to be killed
# and restores previous brightness on exit.

# Brightness will be lowered to this value.
min_brightness=5

# If your video driver works with xbacklight, set -time and -steps for fading
# to $min_brightness here. Setting steps to 1 disables fading.
fade_time=200
fade_steps=20

get_brightness() {
  xbacklight -get
}

set_brightness() {
  xbacklight -steps 1 -set "$1"
}

fade_brightness() {
  xbacklight -time "$fade_time" -steps "$fade_steps" -set "$1"
}

dim() {
  trap 'exit 0' TERM INT
  trap "set_brightness $(get_brightness); kill %%" EXIT
  fade_brightness "$min_brightness"
  sleep infinity &
  wait
}

# Don't dim screen if video is playing
drivers="/proc/asound/card*/pcm*/sub*/status"
if ! cat $drivers | grep -q "state: RUNNING"; then
  dim
fi
