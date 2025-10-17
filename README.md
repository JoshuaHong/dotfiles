<div align = center>

# Dotfiles
The Arch Linux environment.
</div>

<br>

# Programs
* Operating system: [Arch Linux](https://www.archlinux.org)
    > Provides more simplicity and configurability than any other distribution.

<br>

# Pre-installation

### Install the ISO
* [Download](https://archlinux.org/download) the latest ".iso" file and the respective ".iso.sig" PGP signature.
* Fetch the signing key: <code>gpg --auto-key-locate clear,wkd -v --locate-external-key pierre@archlinux.org</code>
* Verify the signature: <code>gpg --verify archlinux-x86_64.iso.sig archlinux-x86_64.iso</code>
* Install the ISO to a drive: <code>dd if=archlinux-x86_64.iso of=/dev/<code><var>DRIVE</var></code> bs=4096 status=progress && sync</code>

### Boot the installation medium
* Disable secure boot
    > 📝 **Note**: Arch Linux does not support secure boot. Secure boot can be set up after installation.
* Use UEFI boot mode
    > 📝 **Note**: UEFI is the newest standard, and most modern hardware does not support legacy BIOS boot.
* Ensure that the boot order prioritizes the external bootable media over the internal disk devices
* Boot into the live environment

### Verify the boot mode
* Ensure the UEFI bitness exists: <code>cat /sys/firmware/efi/fw_platform_size</code>
    > 📝 **Note**: "64" means the system is booted in 64-bit x64 UEFI mode. \
    > 📝 **Note**: "32" means the system is booted in 32-bit IA32 UEFI mode. \
    > ⚠️ **Warning**: "No such file or directory" means the system may be booted in BIOS mode.

### Configure networking
* Connect to the internet: <code>iwctl station <code><var>DEVICE</var></code> connect <code><var>SSID</var></code></code>
    > 💡 **Tip**: Find the device name: <code>iwctl device list</code> \
    > 💡 **Tip**: Find the SSID name: <code>iwctl station <code><var>DEVICE</code></var> get-networks</code>
* Verify the connection: <code>ping -c 3 ping.archlinux.org</code>
* Ensure the system clock is synchronized: <code>timedatectl</code>

### Partition the disks
* Create the partitions: <code>fdisk /dev/<code><var>DISK</var></code></code>
    * Delete all existing partitions and signatures
        > ⚠️ **Warning**: This will wipe out the entire drive.
    * Create a new empty GPT partition table
        > 📝 **Note**: GPT is the latest and recommended standard allowing more partitions and handles larger disk sizes.
    * Create a 550M EFI System
        > 📝 **Note**: The author of gdisk suggests 550M.
    * Create a RAMx2GB Linux Swap
        > 📝 **Note**: The rule of thumb is 2xRAM for hibernation.
    * Create a 30G Linux root (x86-64)
        > 📝 **Note**: 15G is the recommended minimum, so 30G should be sufficient.
    * Create the rest for Linux home

### Format the partitions
* Format the boot partition: <code>mkfs.fat -F 32 /dev/<code><var>BOOT_PARTITION</var></code></code>
    > 📝 **Note**: The EFI system partition must be formatted as FAT32 on UEFI systems.
* Set the boot partition label name: <code>fatlabel /dev/<code><var>BOOT_PARTITION</var></code> BOOT</code>
    > 💡 **Tip**: Assigning labels to partitions helps referring to them later without their numbers. \
    > 📝 **Note**: FAT volume labels are stored in uppercase, and warns that lowercase labels may not work on some systems.
* Create the swap partition: <code>mkswap -L SWAP /dev/<code><var>SWAP_PARTITION</var></code></code>
    > 💡 **Tip**: Any existing swap partitions may need to be removed in advance: <code>swapoff -a</code>.
* Format the root partition: <code>mkfs.ext4 -L ROOT /dev/<code><var>ROOT_PARTITION</var></code></code>
    > 📝 **Note**: EXT4 is the standard and reliable file system for Linux.
* Format the home partition: <code>mkfs.ext4 -L HOME /dev/<code><var>HOME_PARTITION</var></code></code>

### Mount the file systems
* Mount the root partition: <code>mount /dev/<code><var>ROOT_PARTITION</var></code> /mnt</code>
* Mount the boot partition: <code>mount --mkdir /dev/<code><var>BOOT_PARTITION</var></code> /mnt/boot</code>
* Mount the home partition: <code>mount --mkdir /dev/<code><var>HOME_PARTITION</var></code> /mnt/home</code>
* Enable the swap volume: <code>swapon /dev/<code><var>SWAP_PARTITION</var></code></code>

<br>

# Packages
List all explicitly installed packages that are not direct dependencies (includes optional dependencies): <code>pacman -Qentt</code>

Count: 0

| Package | Justification |
| ------- | ------------- |

\* AUR package
