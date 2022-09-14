# Dotfiles
Setup for the Arch Linux environment.

## Pre-installation

### BIOS configuration
* Use UEFI boot mode
* Disable secure boot

### Connect to the internet
* Use iwd: `iwctl station <device> connect <SSID>` \
\* To find the device run: `iwctl device list` \
\* To find the SSID run: `iwctl station <device> get-networks`

### Partition the disks
* Use fdisk: `fdisk /dev/nvme0n1`
* Delete all partitions
* Create a new empty GPT partition table
* Create a 550M EFI System
* Create a 4G Linux Swap
* Create a 30G Linux root (x86-64)
* Create the rest for Linux home

### Format the partitions
* Format the boot partition: `mkfs.fat -F 32 /dev/nvme0n1p1`
* Create the swap partition: `mkswap /dev/nvme0n1p2`
* Format the root partition: `mkfs.ext4 /dev/nvme0n1p3`
* Format the home partition: `mkfs.ext4 /dev/nvme0n1p4`

### Mount the file systems
* Mount the root partition: `mount /dev/nvme0n1p3 /mnt`
* Mount the boot partition: `mount --mkdir /dev/nvme0n1p1 /mnt/boot`
* Enable the swap volume: `swapon /dev/nvme0n1p2`

## Installation

### Install essential packages
* Install the microcode, a network manager, and a text editor: `pacman -S intel-ucode iwd neovim`
* Enable iwd: `systemctl enable --now iwd.service systemd-resolved.service`
* Create the iwd configuration file `/etc/iwd/main.conf`:
    ```
    [General]
    EnableNetworkConfiguration=true

    [Network]
    EnableIPv6=true
    ```

### Boot loader
* Install systemd-boot: `bootctl install`
* Edit the loader configuration file `/boot/loader/loader.conf`:
    ```
    default    arch.conf
    ```
* Create the Arch configuration file `/boot/loader/entries/arch.conf`:
    ```
    title   Arch Linux
    linux   /vmlinuz-linux
    initrd  /intel-ucode.img
    initrd  /initramfs-linux.img
    options root=UUID=<UUID> rw
    ```
    \* To find the UUID of the **root** partition in vim run: `:r! blkid`

* Create a Pacman hook for automatic updates in `/etc/pacman.d/hooks/100-systemd-boot.hook`:
    ```
    [Trigger]
    Type = Package
    Operation = Upgrade
    Target = systemd

    [Action]
    Description = Gracefully upgrading systemd-boot...
    When = PostTransaction
    Exec = /usr/bin/systemctl restart systemd-boot-update.service
    ```

## Post-installation

### Errors

#### tpm tpm0: [Firmware Bug]: TPM interrupt not working
* In the BIOS change Security->TPM Availability from Available to Hidden

#### Screen flashes while booting on TTY
* Add the following to `/etc/mkinitcpio.conf`:
```
MODULES=(i915)
```
* Recreate the initramfs image: `mkinitcpio -P`

#### cros-usbpd-charger cros-usbpd-charger.5.auto: Unexpected number of charge port count
* No solution found

### Silence the boot output
* Add the `quiet` kernel parameter in `/boot/loader/entries/arch.conf`:
```
options root=UUID=<UUID> rw quiet
```
* Recreate the initramfs image: `mkinitcpio -P`
