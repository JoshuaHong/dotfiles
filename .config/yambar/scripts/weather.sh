#!/bin/bash
#
# Yambar script to display the weather.

LOCATION="Sunnyvale"

weather=($(curl --fail --silent "v2d.wttr.in/${LOCATION}?m" | grep "Weather:"))
icon="${weather[1]}"
temperature="${weather[-4]}"
temperature="${temperature//","/""}"  # Replace "," with "".
temperature="${temperature//"+"/""}"  # Replace "+" with "".
temperature="${temperature//"-0"/"0"}"  # Replace "-0" with "0".
echo "weather|string|${icon} ${temperature}"
echo ""
