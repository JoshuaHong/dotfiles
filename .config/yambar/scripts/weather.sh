#!/bin/bash
#
# Yambar script to display the weather.

declare -gr LOCATION="Sunnyvale"
declare -gr RETRY_DELAY_TIME_SECONDS=10

main() {
    local -ar weather=($(parseWeather "$(getWeatherOrRetry)"))
    local -r icon="${weather[1]}"
    local -r temperature="$(formatTemperature "${weather[-4]}")"
    echo -e "weather|string|${icon} ${temperature}\n"
}

parseWeather() {
    local -r weatherReport="${1}"
    echo "${weatherReport}" | grep "Weather:"
}

getWeatherOrRetry() {
    local weatherReport="$(fetchWeatherReport)"
    while isEmpty "${weatherReport}"; do
        sleep "${RETRY_DELAY_TIME_SECONDS}"
        weatherReport="$(fetchWeatherReport)"
    done
    echo "${weatherReport}"
}

fetchWeatherReport() {
    curl --fail --silent "v2d.wttr.in/${LOCATION}?m"
}

isEmpty() {
    local -r variable="${1}"
    [[ -z "${variable[@]}" ]]
}

formatTemperature() {
    local temperature="${1}"
    temperature="${temperature//","/""}"  # Replace "," with "".
    temperature="${temperature//"+"/""}"  # Replace "+" with "".
    temperature="${temperature//"-0"/"0"}"  # Replace "-0" with "0".
    echo "${temperature}"
}

main
