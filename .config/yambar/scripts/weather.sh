#!/bin/bash
#
# Yambar script to display the weather.

LOCATION="Sunnyvale"

weather=($(curl --fail --silent "wttr.in/${LOCATION}?m&format=1"))
icon="${weather[0]}"
temperature="${weather[1]}"
temperature="${temperature//"+"/""}"  # Replace "+" with "".
temperature="${temperature//"-0"/"0"}"  # Replace "-0" with "0".
echo "weather|string|${icon} ${temperature}"
echo ""
