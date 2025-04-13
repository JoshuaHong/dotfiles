#!/bin/bash
#
# Yambar script to display the weather.

LOCATION="Sunnyvale"

main() {
    weather="$(fetchWeather)"
    while [[ -z ${weather} ]]; do
        sleep 10
        weather="$(fetchWeather)"
    done

    weather=($(echo "${weather}" | grep "Weather:"))
    icon="${weather[1]}"
    temperature="${weather[-4]}"
    temperature="${temperature//","/""}"  # Replace "," with "".
    temperature="${temperature//"+"/""}"  # Replace "+" with "".
    temperature="${temperature//"-0"/"0"}"  # Replace "-0" with "0".
    echo "weather|string|${icon} ${temperature}"
    echo ""
}

fetchWeather() {
    curl --fail --silent "v2d.wttr.in/${LOCATION}?m"
}

main
