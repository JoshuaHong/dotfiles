#!/bin/bash

# Gives a rofi prompt to mount or unmount loaded devices.

# Outputs to standard error.
# Requires a message "$@" to print.
echoerr() {
  echo "$@" 1>&2
}

# Sends notifications.
# Requires the same parameters "$@" as the dunstify command.
notify() {
  dunstify "$@"
}

storageDevices="$(lsblk -o "NAME,SIZE,TYPE,TRAN" | grep "usb" | grep "disk" \
    | awk '{
  printf NR ": 💽 "
  if (system("mount -l | grep -q /mnt/" $1)) {
    printf "Mount "
  } else {
    printf "Unmount "
  }
  print "/dev/" $1 " (" $2 ")";
}')"

mobileDevices="$(simple-mtpfs -l | awk '{
  printf $1 " 📱 "
  if (system("mount -l | grep -q /mnt/" $2)) {
    printf "Mount "
  } else {
    printf "Unmount "
  }
  print $2
}')"

# device="[#]: [type] [action] [path] ([size])"
# Ex: "1: 💽 Mount /dev/sda (32G)"
if [[ -z "$storageDevices" ]]; then
  device="$(echo -e "$mobileDevices" \
      | rofi -dmenu -i -p "Select device to mount or unmount")"
else
  device="$(echo -e "$storageDevices\n$mobileDevices" \
    | rofi -dmenu -i -p "Select device to mount or unmount")"
fi
number="$(echo -e "$device" | awk '{print $1}')"
type="$(echo -e "$device" | awk '{print $2}')"
action="$(echo -e "$device" | awk '{print $3}')"
path="$(echo -e "$device" | awk '{print $4}')"
name="${path##*/}"

if [[ "$action" == "Mount" ]]; then
  sudo mkdir -p "/mnt/$name"
  if [[ "$type" == "💽" ]]; then
    if sudo mount "/dev/$name" "/mnt/$name"; then
      notify "Mounted" "💽 $path"
      pkill -SIGRTMIN+12 i3blocks
    else
      notify "Mounting Failed" "❌ $path"
    fi
  elif [[ "$type" == "📱" ]]; then
    if sudo simple-mtpfs --device "$number" "/mnt/$name"; then
      notify "Mounted" "📱 $path"
      pkill -SIGRTMIN+12 i3blocks
    else 
      notify "Mounting Failed" "❌ $path"
    fi
  fi
elif [[ "$action" == "Unmount" ]]; then
  if sudo fusermount -u "/mnt/$name"; then
    notify "Unmounted" "📵 $path";
    sudo rmdir "/mnt/$name"
    pkill -SIGRTMIN+12 i3blocks
  else
    notify "Unmounting Failed" "❌ $path"
  fi
fi
