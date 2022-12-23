#!/bin/bash
#
# Display the current weather.
#
# Usage: weather [options] [location].
#
# Dependencies: [curl].

set -o errexit
set -o nounset
set -o pipefail

# Dependencies.
declare -agr DEPENDENCIES=("curl")

# Command-line arguments.
declare -g location=""

main() {
  assertDependencies
  parseArguments "${@}"
  displayWeather
}

# Assrt that the dependencies exist.
assertDependencies() {
  for dependency in "${DEPENDENCIES[@]}"; do
    if ! programExists "${dependency}"; then
      echoError "Error: Missing dependency \"${dependency}\"."
      printUsageMessage
      exit 1
    fi
  done
}

# Parse the command-line arguments.
parseArguments() {
  parseOptions "${@}"
  local numArgs="$(("${#}" - "${OPTIND}" + 1))"
  if [[ "${numArgs}" -gt 1 ]]; then
    echoError "Error: Invalid number of arguments."
    printUsageMessage
    exit 1
  fi
  location="${1:-}"  # Set the location if specified, or empty otherwise.
  location="${location// /+}"  # Replace " " with "+".
}

# Display the current weather.
displayWeather() {
  local weatherReport="$(fetchWeatherReport)"
  if isVariableEmpty "${weatherReport}"; then
    echo " °C"
    exit 1
  fi
  declare -ar weather=($(echo "${weatherReport}" | grep "Weather:"))
  local condition="${weather[1]}"
  local temperature="${weather[-4]}"
  temperature="${temperature//,/}"  # Replace "," with "".
  temperature="${temperature//+/}"  # Replace "+" with "".
  temperature="${temperature//-0/0}"  # Replace "-0" with "0".
  echo "${condition}  ${temperature}"
}

# Fetch the full weather report.
fetchWeatherReport() {
  curl -fs "https://v2d.wttr.in/${location}"
}

# Parse the command-line options.
parseOptions() {
  while getopts ":h" flag; do
    case "${flag}" in
      h)
        printHelpMessage
        exit 0
        ;;
      *)
        echoError "Error: Invalid option."
        printUsageMessage
        exit 1
        ;;
    esac
  done
}

# Print the help message.
printHelpMessage() {
  echo "Weather - Display the current weather using wttr.in."
  echo -e "\nUsage: weather [options] [location]"
  echo -e "\nOptions:"
  echo -e "\t-h\t\tPrint the help menu and exit."
  echo -e "\nArguments:"
  echo -e "\tlocation\tThe location from which to fetch the weather."
  echo -e "\t\t\tMust be a valid location in wttr.in."
  echo -e "\t\t\tIf unspecified, fetches the weather based on IP address."
  echo -e "\nDependencies:"
  echo -e "\tcurl\t\tTo fetch the current weather."
}

# Print the usage message after an error.
printUsageMessage() {
  echo "Usage: weather [options] [location]"
  echo "Type \"weather -h\" for more information."
}

# Print the error message to standard output.
echoError() {
  local errorMessage="${*}"
  echo -e "${errorMessage}" 1>&2
}

# Return true if the program exists, false otherwise.
programExists() {
  local program="${1}"
  command -v "${program}" > /dev/null 2>&1
}

# Return true if the variable is empty, false otherwise.
isVariableEmpty() {
  local variable="${1}"
  [[ -z "${variable}" ]]
}

main "${@}"
