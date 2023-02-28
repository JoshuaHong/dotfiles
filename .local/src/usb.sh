#!/bin/bash
#
# Manage USB device mounting.
#
# Usage: usb [options].
#
# Dependencies: [chown, grep, jmtpfs, mkdir, mount, rmdir, sed, sudo, umount].

# Imports.
source "/home/josh/.local/src/helpers.sh"

# Constants.
declare -agr DEPENDENCIES=("chown" "grep" "jmtpfs" "mkdir" "mount" "rmdir" \
    "sed" "sudo" "umount")
declare -gr OPTSTRING="lm:p:u:"
declare -gir MAX_NUM_OPERANDS=0
declare -gir MIN_NUM_OPERANDS=0
declare -Agr MSC_DEVICE_ATTRIBUTES=(["SIZE"]=0 ["MOUNTPOINTS"]=1)
declare -Agr MTP_DEVICE_ATTRIBUTES=(["BUS_LOCATION"]=0 ["DEV_NUM"]=1 \
    ["PRODUCT_ID"]=2 ["VENDOR_ID"]=3 ["PRODUCT"]=4 ["VENDOR"]=5)
declare -gr BASE_MOUNTPOINT="/mnt"
declare -gr MTP_DEVICE_NAME_PREFIX="mtp"

# Variables.
declare -Ag options=()
declare -ag operands=()
declare -Ag mscDevices=()
declare -Ag mtpDevices=()
declare -g baseMountpoint="${BASE_MOUNTPOINT}"


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
  fetchAvailableDevices
  if isVariableSet options["l"]; then
    listDevices
    exit 0
  fi
  if isVariableSet options["p"]; then
    setMountpoint "${options["p"]}"
  fi
  if isVariableSet options["m"]; then
    mountDevice "${options["m"]}"
  elif isVariableSet options["u"]; then
    unmountDevice "${options["u"]}"
  fi
}

# Fetch available devices.
fetchAvailableDevices() {
  fetchMscDevices
  fetchMtpDevices
}

# Set the custom mountpoint.
# Parameters:
#   mountpoint (string): The custom mountpoint to use.
setMountpoint() {
  local -r mountpoint="${1}"
  if [[ "${#options[@]}" -eq 1 ]]; then
    echoError "Error: Specify another option along with \"-p\"."
    printUsageMessage
    exit 1
  fi
  assertDirectoryExists "${mountpoint}"
  baseMountpoint="${mountpoint}"
}

# List available devices.
listDevices() {
  printMscDevices mscDevices
  printMtpDevices mtpDevices
}

# Mount the selected device.
# Parameters:
#   name (string): The name of the device to mount.
mountDevice() {
  local -r name="${1}"
  if isMscDevice "${name}"; then
    mountMscDevice "${name}"
  elif isMtpDevice "${name}"; then
    mountMtpDevice "${name}"
  else
    echoError "Error: Device \"${name}\" not found."
    exit 1
  fi
}

# Unmount the selected device.
# Parameters:
#   name (string): The name of the device to unmount.
unmountDevice() {
  local -r name="${1}"
  if isMscDevice "${name}"; then
    unmountMscDevice "${name}"
  elif isMtpDevice "${name}"; then
    unmountMtpDevice "${name}"
  else
    echoError "Error: Device \"${name}\" not found."
    exit 1
  fi
}

# Print available MSC devices.
printMscDevices() {
  for i in "${!mscDevices[@]}"; do
    readarray -d "," -t mscDeviceAttributes < <(echo -n "${mscDevices["${i}"]}")
    echo -n "${i} "
    echo -n "(${mscDeviceAttributes["${MSC_DEVICE_ATTRIBUTES["SIZE"]}"]}) "
    echo "[${mscDeviceAttributes["${MSC_DEVICE_ATTRIBUTES["MOUNTPOINTS"]}"]-"unmounted"}]"
  done
}

# Print available MTP devices.
printMtpDevices() {
  for i in "${!mtpDevices[@]}"; do
    readarray -d "," -t mtpDeviceAttributes < <(echo -n "${mtpDevices["${i}"]}")
    echo -n "${i} "
    echo -n "(${mtpDeviceAttributes["${MTP_DEVICE_ATTRIBUTES["VENDOR"]}"]} "
    echo -n "${mtpDeviceAttributes["${MTP_DEVICE_ATTRIBUTES["PRODUCT"]}"]}) "
    if isMtpDeviceMounted "${i}"; then
      echo "[${baseMountpoint}/${i}]"
    else
      echo "[unmounted]"
    fi
  done
}

# Mount the selected MSC device.
# Parameters:
#   name (string): The name of the MSC device to mount.
mountMscDevice() {
  local -r name="${1}"
  local -r mountpoint="${baseMountpoint}/${name}"
  assertMscDeviceUnmounted "${name}"
  assertBaseMountpointNotBusy
  assertDirectoryNotExists "${mountpoint}"
  sudo mkdir "${mountpoint}"
  sudo mount "/dev/${name}" "${mountpoint}" || sudo rmdir "${mountpoint}"
}

# Mount the selected MTP device.
# Parameters:
#   name (string): The name of the MTP device to mount.
mountMtpDevice() {
  local -r name="${1}"
  local -r mountpoint="${baseMountpoint}/${name}"
  assertMtpDeviceUnmounted "${name}"
  assertBaseMountpointNotBusy
  assertDirectoryNotExists "${mountpoint}"
  sudo mkdir "${mountpoint}"
  sudo chown "${USER}:${USER}" "${mountpoint}"
  readarray -d "," -t mtpDeviceAttributes \
      < <(echo -n "${mtpDevices["${name}"]}")
  jmtpfs -device="${mtpDeviceAttributes["${MTP_DEVICE_ATTRIBUTES["BUS_LOCATION"]}"]},${mtpDeviceAttributes["${MTP_DEVICE_ATTRIBUTES["DEV_NUM"]}"]}" \
      "${mountpoint}" > /dev/null || sudo rmdir "${mountpoint}"
  ls ${mountpoint} > /dev/null 2>&1 \
      || echoError "Warning: Enable USB file transfer on the device."
}

# Unmount the selected MSC device.
# Parameters:
#   name (string): The name of the MSC device to unmount.
unmountMscDevice() {
  local -r name="${1}"
  assertMscDeviceMounted "${name}"
  readarray -d "," -t mscDeviceAttributes \
      < <(echo -n "${mscDevices["${name}"]}")
  local -ar mountpoints=(${mscDeviceAttributes["${MSC_DEVICE_ATTRIBUTES["MOUNTPOINTS"]}"]})
  for mountpoint in "${mountpoints[@]}"; do
    sudo umount "${mountpoint}"
  done
  local -r mountpoint="${baseMountpoint}/${name}"
  sudo rmdir "${mountpoint}" > /dev/null 2>&1  # Ignore no such directory error.
}

# Unmount the selected MTP device.
# Parameters:
#   name (string): The name of the MTP device to unmount.
unmountMtpDevice() {
  local -r name="${1}"
  local -r mountpoint="${baseMountpoint}/${name}"
  assertMtpDeviceMounted "${name}"
  fusermount -u "${mountpoint}"
  sudo rmdir "${mountpoint}" > /dev/null 2>&1  # Ignore no such directory error.
}

# Fetch available MSC devices.
fetchMscDevices() {
  # Get all lines where TRAN=usb and TYPE=disk.
  local lsblkOutput="$(lsblk --output "NAME,SIZE,MOUNTPOINTS,TRAN,TYPE" \
      --pairs | grep "TRAN=\"usb\" TYPE=\"disk\"")"
  lsblkOutput="${lsblkOutput//"NAME="/""}"  # Remove "NAME=".
  lsblkOutput="${lsblkOutput//"SIZE="/""}"  # Remove "SIZE=".
  lsblkOutput="${lsblkOutput//"MOUNTPOINTS="/""}"  # Remove "MOUNTPOINTS=".
  lsblkOutput="${lsblkOutput//" TRAN=\"usb\""/""}"  # Remove " TRAN=\"usb\"".
  lsblkOutput="${lsblkOutput//" TYPE=\"disk\""/""}"  # Remove " TYPE=\"disk\"".
  lsblkOutput="${lsblkOutput//" "/","}"  # Replace " " with ",".
  lsblkOutput="${lsblkOutput//"\""/""}"  # Remove "\"".
  readarray -t lsblkMscDevices < <(echo -n "${lsblkOutput}")
  for mscDevice in "${lsblkMscDevices[@]}"; do
    # Replace "\\x0a" with " ". "\x0a" is used to separate multiple mountpoints.
    mscDevice="${mscDevice//\\x0a/" "}"
    # Set the device name as the index, and the other attributes as the value.
    mscDevices["${mscDevice%%,*}"]="${mscDevice#*,}"
  done
}

# Fetch available MTP devices.
fetchMtpDevices() {
  # Get all lines after the regular expression "^Available devices".
  local jmtpfsOutput="$(jmtpfs --listDevices \
      | sed --expression='1,/^Available devices/d')"
  jmtpfsOutput="${jmtpfsOutput//", "/","}"  # Replace ", " with ",".
  readarray -t jmtpfsMtpDevices < <(echo -n "${jmtpfsOutput}")
  for i in "${!jmtpfsMtpDevices[@]}"; do
    mtpDevices["${MTP_DEVICE_NAME_PREFIX}${i}"]="${jmtpfsMtpDevices["${i}"]}"
  done
}

# Return true if the name belongs to an available MSC device, false otherwise.
# Parameters:
#   name (string): The name of the device to check if it is an MSC device.
isMscDevice() {
  local -r name="${1}"
  isVariableSet mscDevices["${name}"]
}

# Return true if the name belongs to an available MTP device, false otherwise.
# Parameters:
#   name (string): The name of the device to check if it is an MTP device.
isMtpDevice() {
  local -r name="${1}"
  isVariableSet mtpDevices["${name}"]
}

# Return true if the MSC device is mounted, false otherwise.
# Parameters:
#   name (string): The name of the MSC device to check if it is mounted.
isMscDeviceMounted() {
  local -r name="${1}"
  readarray -d "," -t mscDeviceAttributes \
      < <(echo -n "${mscDevices["${name}"]}")
  isVariableSet mscDeviceAttributes["${MSC_DEVICE_ATTRIBUTES["MOUNTPOINTS"]}"]
}

# Return true if the MTP device is mounted, false otherwise.
# Parameters:
#   name (string): The name of the MTP device to check if it is mounted.
isMtpDeviceMounted() {
  local -r name="${1}"
  mount | grep -q "${baseMountpoint}/${name}"
}

# Assert that the MSC device is mounted.
# Parameters:
#   name (string): The name of the MSC device to check if it is mounted.
assertMscDeviceMounted() {
  local -r name="${1}"
  if ! isMscDeviceMounted "${name}"; then
    echoError "Error: Device \"${name}\" is already unmounted."
    exit 1
  fi
}

# Assert that the MSC device is unmounted.
# Parameters:
#   name (string): The name of the MSC device to check if it is unmounted.
assertMscDeviceUnmounted() {
  local -r name="${1}"
  if isMscDeviceMounted "${name}"; then
    echoError "Error: Device \"${name}\" is already mounted."
    exit 1
  fi
}

# Assert that the MTP device is mounted.
# Parameters:
#   name (string): The name of the MTP device to check if it is mounted.
assertMtpDeviceMounted() {
  local -r name="${1}"
  if ! isMtpDeviceMounted "${name}"; then
    echoError "Error: Device \"${name}\" is already unmounted."
    exit 1
  fi
}

# Assert that the MTP device is unmounted.
# Parameters:
#   name (string): The name of the MTP device to check if it is unmounted.
assertMtpDeviceUnmounted() {
  local -r name="${1}"
  if isMtpDeviceMounted "${name}"; then
    echoError "Error: Device \"${name}\" is already mounted."
    exit 1
  fi
}

# Assert that the base mountpoint itself is not being used as a mountpoint.
assertBaseMountpointNotBusy() {
  if mount | grep -q "${baseMountpoint} "; then
    echoError "Error: Mountpoint \"${baseMountpoint}\" is busy."
    exit 1
  fi
}

# Print the help message.
printHelpMessage() {
  echo "Usb - Manage USB device mounting."
  echo -e "\nUsage: usb [options]"
  echo -e "\nOptions:"
  echo -e "\t-h\t\tPrint the help menu."
  echo -e "\t-l\t\tList the available devices."
  echo -e "\t-m name\t\tMount the device."
  echo -e "\t-p mountpoint\tSpecify the base mountpoint. Defaults to /mnt."
  echo -e "\t-u name\t\tUnmount the device."
  echo -e "\nDependencies:"
  echo -e "\tchown\t\tTo allow users access to the mounted filesystems."
  echo -e "\tgrep\t\tTo search for patterns."
  echo -e "\tjmtpfs\t\tTo mount and unmount MTP devices."
  echo -e "\tmkdir\t\tTo create the mount point."
  echo -e "\tmount\t\tTo mount MSC devices."
  echo -e "\trmdir\t\tTo remove the mount point."
  echo -e "\tsed\t\tTo select specific text."
  echo -e "\tsudo\t\tTo mount, unmount, and manage directories."
  echo -e "\tumount\t\tTo unmount MSC devices."
}

# Print the usage message.
printUsageMessage() {
  echo "Usage: usb [options]"
  echo "Type \"usb -h\" for more information."
}

setUp "${@}"
main
