#!/bin/bash
#
# Display the current weather.
#
# Usage: weather [options] [location].
#
# Dependencies: [curl, grep].

# Imports.
source "/home/josh/.local/src/helpers.sh"

# Constants.
declare -agr DEPENDENCIES=("curl" "grep")
declare -gr OPTSTRING=""
declare -gir MAX_NUM_ARGUMENTS=1
declare -gr WEATHER_API_URL="https://v2d.wttr.in"

# Variables.
declare -Ag options=()
declare -ag operands=()
declare -g location=""

# Set-up for the script.
# Parameters:
#   arguments (array[string]): The array of arguments to the program.
setUp() {
  local -ar arguments=("${@}")
  setBashOptions
  assertDependenciesExist "${DEPENDENCIES[@]}"
  parseOptions options "${OPTSTRING}" "${arguments[@]}"
  parseOperands operands "${MAX_NUM_ARGUMENTS}" "${arguments[@]}"
  location="${operands[0]:-}"  # Set the location if specified, empty otherwise.
  location="${location//" "/"+"}"  # Replace " " with "+".
}

# Main function of the script.
main() {
  displayWeather
}


# Display the current weather.
displayWeather() {
  local -r weatherReport="$(fetchWeatherReport)"
  if isVariableEmpty weatherReport; then
    echo " °C"
    exit 1
  fi
  declare -ar weather=($(echo "${weatherReport}" | grep "Weather:"))
  local -r condition="${weather[1]}"
  local temperature="${weather[-4]}"
  temperature="${temperature//","/""}"  # Replace "," with "".
  temperature="${temperature//"+"/""}"  # Replace "+" with "".
  temperature="${temperature//"-0"/"0"}"  # Replace "-0" with "0".
  echo "${condition}  ${temperature}"
}

# Fetch the full weather report.
fetchWeatherReport() {
  curl -fs "${WEATHER_API_URL}/${location}"
}

# Print the help message.
printHelpMessage() {
  echo "Weather - Display the current weather using wttr.in."
  echo -e "\nUsage: weather [options] [location]"
  echo -e "\nOptions:"
  echo -e "\t-h\t\tPrint the help menu."
  echo -e "\nArguments:"
  echo -e "\tlocation\tThe location from which to fetch the weather."
  echo -e "\t\t\tMust be a valid location in wttr.in."
  echo -e "\t\t\tIf unspecified, fetches the weather based on IP address."
  echo -e "\nDependencies:"
  echo -e "\tcurl\t\tTo fetch the current weather."
  echo -e "\tgrep\t\tTo match patterns."
}

# Print the usage message.
printUsageMessage() {
  echo "Usage: weather [options] [location]"
  echo "Type \"weather -h\" for more information."
}

setUp "${@}"
main
