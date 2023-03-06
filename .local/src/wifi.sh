#!/bin/bash
#
# Manage wireless networking.
#
# Usage: wifi [options].
#
# Dependencies: [iwctl].

# Imports.
source "/home/josh/.local/src/helpers.sh"

# Constants.
declare -agr DEPENDENCIES=("iwctl")
declare -gr OPTSTRING="c:dlw:"
declare -gir MAX_NUM_OPERANDS=0
declare -gir MIN_NUM_OPERANDS=0

# Variables.
declare -Ag options=()
declare -ag operands=()
declare -g wlan="wlan0"

# Set-up for the script.
# Parameters:
#   arguments (array[string]): The array of arguments to the program.
setUp() {
  local -ar arguments=("${@}")
  setBashOptions
  assertDependenciesExist "${DEPENDENCIES[@]}"
  parseOptions options "${OPTSTRING}" "${arguments[@]}"
  parseOperands operands "${MAX_NUM_OPERANDS}" "${MIN_NUM_OPERANDS}" \
      "${arguments[@]}"
}

# Main function of the script.
main() {
  if isVariableEmpty options; then
    printHelpMessage
    exit 0
  fi
  if isVariableSet options["l"]; then
    listNetworks
    exit 0
  fi
  if isVariableSet options["w"]; then
    setWlan "${options["w"]}"
  fi
  if isVariableSet options["c"]; then
    connect "${options["c"]}"
  elif isVariableSet options["d"]; then
    disconnect
  fi
}

# Set the custom WLAN.
# Parameters:
#   wlan (string): The custom WLAN to use.
setWlan() {
  if [[ "${#options[@]}" -eq 1 ]]; then
    echoError "Error: Specify another option along with \"-w\"."
    printUsageMessage
    exit 1
  fi
  wlan="${1}"
}

# Connect to a network.
# Parameters:
#   name (string): The name of the network to which to connect.
connect() {
  local -r name="${1}"
  iwctl station "${wlan}" connect "${name}"
}

# Disconnect from the network.
disconnect() {
  iwctl station "${wlan}" disconnect
}

# List all available networks.
listNetworks() {
  iwctl station "${wlan}" get-networks
}

# Print the help message.
printHelpMessage() {
  echo "Wifi - Manage wireless networking."
  echo -e "\nConnects to \"${wlan}\" by default."
  echo -e "\nUsage: wifi [options]"
  echo -e "\nOptions:"
  echo -e "\t-c name\t\tConnect to a network."
  echo -e "\t-d\t\tDisconnect from the network."
  echo -e "\t-l\t\tList all available networks."
  echo -e "\t-w wlan\t\tUse a custom wireless local area network."
  echo -e "\nDependencies:"
  echo -e "\tiwctl\t\tTo manage wireless networking."
}

# Print the usage message.
printUsageMessage() {
  echo "Usage: wifi [options]"
  echo "Type \"wifi -h\" for more information."
}

setUp "${@}"
main
