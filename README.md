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
    > 📝 **Note**: Assigning labels to partitions helps referring to them later without their numbers. \
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

# Installation

### Install essential packages
* Install packages: <code>pacstrap -K /mnt base base-devel <code><var>CPU</var></code>-ucode iwd linux linux-firmware neovim</code>
    > 📝 **Note**: The CPU is either "amd" or "intel". \
    > ⚠️ **Warning**: The wireless daemon is important for connecting to the internet after installation.

# Configuration

### Configure the system
* Generate the fstab file: <code>genfstab -L /mnt >> /mnt/etc/fstab</code>
* Enter the new environment: <code>arch-chroot /mnt</code>
* Set the time zone: <code>ln -sf /usr/share/zoneinfo/<code><var>REGION</var></code>/<code><var>CITY</var></code> /etc/localtime</code>
    > 💡 **Tip**: All time zones can be found in <code>/usr/share/zoneinfo</code>.
* Set the hardware clock: <code>hwclock --systohc</code>
* Update the locale generation file: <code>[/etc/locale.gen](https://raw.githubusercontent.com/JoshuaHong/dotfiles/refs/heads/master/etc/locale.gen)</code>
* Generate the locales: <code>locale-gen</code>
* Create the locale configuration file: <code>[/etc/locale.conf](https://raw.githubusercontent.com/JoshuaHong/dotfiles/refs/heads/master/etc/locale.conf)</code>
* Create the hostname file: <code>[/etc/hostname](https://raw.githubusercontent.com/JoshuaHong/dotfiles/refs/heads/master/etc/hostname)</code>
* Recreate the initramfs image: <code>mkinitcpio -P</code>
* Set the root password: <code>passwd</code>

### Configure the boot loader
* Install the boot manager: <code>pacman -S efibootmgr</code>
    > 📝 Note: Use EFISTUB to boot the kernel directly without a bootloader.
* Create the boot entry: <code>efibootmgr --create --disk /dev/<code><var>DISK</var></code> --part <code><var>BOOT_PARTITION_NUMBER</var></code> --label "Arch Linux" --loader /vmlinuz-linux --unicode 'root=LABEL=ROOT resume=LABEL=SWAP rw quiet initrd=\\<code><var>CPU</var></code>-ucode.img initrd=\initramfs-linux.img'</code>
    > 📝 **Note**: If for example the boot partition is on "/dev/nvme0n1p1", then the DISK is "nvme0n1" and the BOOT_PARTITION_NUMBER is "1". \
    > 📝 **Note**: The CPU is either "amd" or "intel".
* Verify the entry: <code>efibootmgr --unicode</code>
    > 💡 **Tip**: The boot order can be changed: <code>efibootmgr --bootorder <code><var>####</var></code>,<code><var>####</var></code> --unicode</code>

# Reboot
* Exit the chroot environment: <code>exit</code>
* Unmount the drive: <code>umount -R /mnt</code>
* Reboot the machine: <code>reboot</code>

# Post-installation

### Configure the network
* Create the iwd configuration file: <code>[/etc/iwd/main.conf](https://raw.githubusercontent.com/JoshuaHong/dotfiles/refs/heads/master/etc/iwd/main.conf)</code>
* Enable the iwd service: <code>systemctl enable --now iwd.service systemd-resolved.service</code>
* Enable DNS: <code>ln -sf ../run/systemd/resolve/stub-resolv.conf /etc/resolv.conf</code>
* Connect to the internet: <code>iwctl station <code><var>DEVICE</var></code> connect <code><var>SSID</var></code></code>
    > 💡 **Tip**: Find the device name: <code>iwctl device list</code> \
    > 💡 **Tip**: Find the SSID name: <code>iwctl station <code><var>DEVICE</code></var> get-networks</code>
* Verify the connection: <code>ping -c 3 ping.archlinux.org</code>

### Configure users
* Create a new user: <code>useradd --create-home --groups wheel <code><var>USERNAME</var></code></code>
* Assign a password: <code>passwd <code><var>USERNAME</var></code></code>

### Enable privilege elevation
* Install sudo: <code>pacman -S sudo</code>
* Temporarily set the editor to use visudo: <code>export VISUAL=nvim</code>
* Open the configuration file: <code>visudo</code>
* Update the sudoers configuration file: <code>[/etc/sudoers](https://raw.githubusercontent.com/JoshuaHong/dotfiles/refs/heads/master/etc/sudoers)</code>

### Restrict root
* Restrict root login: <code>passwd --lock root</code>
* Update the su configuration file: <code>[/etc/pam.d/su](https://raw.githubusercontent.com/JoshuaHong/dotfiles/refs/heads/master/etc/pam.d/su)</code>
* Update the su-l configuration file: <code>[/etc/pam.d/su-l](https://raw.githubusercontent.com/JoshuaHong/dotfiles/refs/heads/master/etc/pam.d/su-l)</code>
* Install openssh: <code>pacman -S openssh</code>
* Update the openssh configuration file: <code>[/etc/ssh/sshd_config](https://raw.githubusercontent.com/JoshuaHong/dotfiles/refs/heads/master/etc/ssh/sshd_config)</code>

### Configure pacman
* Install pacman-contrib: <code>pacman -S pacman-contrib</code>
* Update the pacman configuration file: <code>[/etc/pacman.conf](https://raw.githubusercontent.com/JoshuaHong/dotfiles/refs/heads/master/etc/pacman.conf)</code>
* Back up the mirrorlist: <code>cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup</code>
* Uncomment every mirror: <code>sed -i 's/^#Server/Server/' /etc/pacman.d/mirrorlist.backup</code>
* Rank the mirrors: <code>rankmirrors -n 10 /etc/pacman.d/mirrorlist.backup > /etc/pacman.d/mirrorlist</code>
* Create the mirrors hook: <code>[/etc/pacman.d/hooks/mirrorupgrade.hook](https://raw.githubusercontent.com/JoshuaHong/dotfiles/refs/heads/master/etc/pacman.d/hooks/mirrorupgrade.hook)</code>
* Update the makepkg configuration file: <code>[/etc/makepkg.conf](https://raw.githubusercontent.com/JoshuaHong/dotfiles/refs/heads/master/etc/makepkg.conf)</code>

### Login as a user
* Exit the root environment: <code>exit</code>
* Login as a user

### Install the AUR helper
* Install git: <code>pacman -S git</code>
* Clone the AUR helper: <code>git clone https://aur.archlinux.org/yay-bin.git</code>
    > 📝 **Note**: Clone the binary package to avoid installing go and compiling the program.
* Build the AUR helper: <code>cd yay-bin/ && makepkg -sir OPTIONS=-debug</code>
    > 📝 **Note**: Avoids build the unnecessary debug package.
* Remove the directory: <code>cd ../ && rm -rf yay-bin/</code>

### Install the remaining packages
* Install all the packages below
    > 📝 **Note**: Install using the following dependencies: "pipewire-jack", "wireplumber".
* Clone the configuration files: <code>git clone https://github.com/JoshuaHong/dotfiles.git && cd dotfiles/</code>
* Copy the configuration files: <code>rm -rf ~/.* && cp -r .bashrc .config/ .local/ .profile .trash/ ~ && rm -rf ../dotfiles/</code>

### Import GPG keys
* Create the gnupg home: <code>mkdir -m 700 ~/.local/share/gnupg/</code>
    > 📝 **Note**: Specific file permissions are needed for the gpg warning: "WARNING: unsafe permissions on homedir".
* Temporarily set the GnuPG home: <code>export GNUPGHOME=~/.local/share/gnupg</code>
* Import the public key: <code>gpg --import <code><var>PUBLIC</var></code>.key</code>
* Import the secret key: <code>gpg --import <code><var>SECRET</var></code>.key</code>
* Import the trust: <code>gpg --import-ownertrust <code><var>TRSUT</var></code>.txt</code>
* Import the revocation certificate: <code>gpg --import <code><var>REVOKE</var></code>.key</code>

### Reboot
* Unset the bash history file path: <code>unset HISTFILE</code>
    > 📝 **Note**: Avoids creating a new bash history file in the home directory.
* Reboot: <code>reboot</code>

<br>

# Packages
List all packages that are not direct dependencies (includes optional dependencies): <code>pacman -Qtt</code>

Count: 11

| Package        | Justification                                                    |
| -------------- | ---------------------------------------------------------------- |
| amd-ucode      | Updates the firmware for system stability.                       |
| base           | Minimal required tools for a basic system.                       |
| base-devel     | Basic tools to build packages.                                   |
| efibootmgr     | Boots Linux without a bootloader by loading the kernel directly. |
| iwd            | Manages networking without a full network manager.               |
| linux          | Linux kernel and modules.                                        |
| linux-firmware | Linux firmware.                                                  |
| neovim         | Lightweight configurable text editor.                            |
| openssh        | Allows remote login with SSH.                                    |
| pacman-contrib | Tools for Pacman systems.                                        |
| yay-bin *      | Installs packages from the Arch User Repository.                 |

\* AUR package
