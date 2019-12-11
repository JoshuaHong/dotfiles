#!/bin/bash

# An i3blocks battery output script
# Takes in a $BLOCK_BUTTON instance for mouse events

# Notifications
notify() {
  dunstify -h string:x-canonical-private-synchronous:"battery" "$@"
}

capacity="$(< /sys/class/power_supply/BAT0/capacity)"
status="$(< /sys/class/power_supply/BAT0/status)"

# Full text
if [[ "$status" == "Discharging" ]]; then
  echo "🔋 $capacity%"
elif [[ "$status" == "Charging" ]]; then
  echo "🔌 $capacity%"
elif [[ "$status" == "Full" ]]; then
  echo "✅ $capacity%"
else
  echo "❓ $capacity%"
fi

# Short text
echo "$capacity%"

# Set urgent flag below 5% or use orange below 20%
if [[ "$capacity" -le 5 ]]; then
  exit 33
elif [[ "$capacity" -le 15 ]]; then
  echo "#FF6700"
fi

# Mouse listener
chargefull="$(< /sys/class/power_supply/BAT0/charge_full)"
chargenow="$(< /sys/class/power_supply/BAT0/charge_now)"
currentnow="$(< /sys/class/power_supply/BAT0/current_now)"
case "$BLOCK_BUTTON" in
  1) # Left click
    if [[ "$status" == "Discharging" ]]; then
      notify "Time To Empty" "🕛 $(echo "$chargenow $currentnow" \
        | awk '{printf "%.0fh %dm", $1/$2, (($1/$2)*60+0.5)%60}')"
    elif [[ "$status" == "Charging" ]]; then
      notify "Time To Full" "🕛 $(echo "$chargefull $chargenow $currentnow" \
        | awk '{printf "%.0fh %dm", ($1-$2)/$3, ((($1-$2)/$3)*60+0.5)%60}')"
    elif [[ "$status" == "Full" ]]; then
      notify "Battery" "✅ Fully Charged"
    else
      notify "Battery" "❓ Unknown State"
    fi
    ;;
esac

exit 0
