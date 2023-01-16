#!/bin/bash
#
# Manage USB device mounting.
#
# Usage: usb [options].
#
# Dependencies: [mount, umount].

# Imports.
source "/home/josh/.local/src/helpers.sh"

# Constants.
declare -agr DEPENDENCIES=("grep" "mount" "umount")
declare -gr OPTSTRING="lm:u:"
declare -gir MAX_NUM_ARGUMENTS=0

# Variables.
declare -Ag options=()
declare -ag operands=()

# Set-up for the script.
# Parameters:
#   arguments (array[string]): The array of arguments to the program.
setUp() {
  local -ag arguments=("${@}")
  setBashOptions
  assertDependenciesExist "${DEPENDENCIES[@]}"
  parseOptions "${OPTSTRING}" options "${arguments[@]}"
  parseOperands "${MAX_NUM_ARGUMENTS}" operands "${arguments[@]}"
}

# Main function of the script.
main() {
  if isVariableSet options["l"]; then
    listDevices
  elif isVariableSet options["m"]; then
    mountDevice "${options["m"]}"
  elif isVariableSet options["u"]; then
    unmountDevice "${options["u"]}"
  else
    printHelpMessage
  fi
}

# List available devices.
listDevices() {
  local -a devices=()
  getDevices devices
  echo -e "NAME\tSIZE\tMOUNTPOINT"
  for device in "${devices[@]}"; do
    echo -e "${device// /"\t"}"  # Replace " " with "\t".
  done
}

# Mount the selected device.
# Parameters:
#   name (string): The name of the device to mount.
mountDevice() {
  local -r name="${1}"
  local -a devices=()
  getDevices devices
  assertDeviceIsUnmounted "${name}" devices
  sudo mkdir "/mnt/${name}"
  sudo mount "/dev/${name}" "/mnt/${name}"
}

# Unmount the selected device.
# Parameters:
#   name (string): The name of the device to unmount.
unmountDevice() {
  local -r name="${1}"
  local -a devices=()
  getDevices devices
  assertDeviceIsMounted "${name}" devices
  sudo umount "/dev/${name}"
  sudo rmdir "/mnt/${name}"
}

# Get available devices.
# Parameters:
#   devices (variable): The variable containing the array of devices.
getDevices() {
  local -n devicesRef="${1}"
  local -ar output=($(lsblk -o "NAME,SIZE,MOUNTPOINTS,TRAN,TYPE" \
      | grep "usb" | grep "disk"))
  local device=""
  for word in "${output[@]}"; do
    if [[ "${word}" == "usb" ]]; then
      continue
    elif [[ "${word}" == "disk" ]]; then
      devicesRef+=("${device::-1}")  # Remove the trailing space.
      device=""
    else
      device+="${word} "
    fi
  done
}

# Assert that the device name exists and is mounted.
# Parameters:
#   name (string): The name of the device to check if it is mounted.
#   devices (variable): The variable containing the array of devices.
assertDeviceIsMounted() {
  local -r name="${1}"
  local -n devicesRef="${2}"
  for device in "${devicesRef[@]}"; do
    if [[ "${name}" == "${device%% *}" ]]; then  # The first word is the name.
      if [[ "${device##* }" =~ "/" ]]; then  # The last word contains "/".
        return 0
      else
        echoError "Error: Device \"${name}\" is already unmounted."
        exit 1
      fi
    fi
  done
  echoError "Error: Device \"${name}\" does not exist."
  exit 1
}

# Assert that the device name exists and is unmounted.
# Parameters:
#   name (string): The name of the device to check if it is unmounted.
#   devices (variable): The variable containing the array of devices.
assertDeviceIsUnmounted() {
  local -r name="${1}"
  local -n devicesRef="${2}"
  for device in "${devicesRef[@]}"; do
    if [[ "${name}" == "${device%% *}" ]]; then
      if [[ ! "${device##* }" =~ "/" ]]; then
        return 0
      else
        echoError "Error: Device \"${name}\" is already mounted."
        exit 1
      fi
    fi
  done
  echoError "Error: Device \"${name}\" does not exist."
  exit 1
}

# Print the help message.
printHelpMessage() {
  echo "Usb - Manage USB device mounting."
  echo -e "\nUsage: usb [options]"
  echo -e "\nOptions:"
  echo -e "\t-h\t\tPrint the help menu and exit."
  echo -e "\t-l\t\tList the devices to mount or unmount."
  echo -e "\t-m name\t\tMount the device."
  echo -e "\t-u name\t\tUnmount the device."
  echo -e "\nDependencies:"
  echo -e "\tgrep\t\tTo match patterns."
  echo -e "\tmount\t\tTo mount a device."
  echo -e "\tumount\t\tTo unmount a device."
}

# Print the usage message.
printUsageMessage() {
  echo "Usage: usb [options]"
  echo "Type \"usb -h\" for more information."
}

setUp "${@}"
main
