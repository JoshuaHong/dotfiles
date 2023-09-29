<div align = center>

# Dotfiles
![screenshot](https://github.com/JoshuaHong/dotfiles/assets/35504995/2827b4a2-c767-427b-be73-fcfefdacefcb)
The Artix Linux environment.
</div>

<br>

# Programs
* Operating system: [Artix Linux](https://artixlinux.org)
* Init system: [Dinit](https://github.com/davmac314/dinit)
  > 📝 **Note:** Dinit is the fastest and simplist and solves problems of the other init systems.

<br>

# Installation

### Install the ISO
* [Download](https://artixlinux.org/download.php) the stable base Dinit ISO and the corresponding PGP signature
* Verify the ISO: <code>gpg --auto-key-retrieve --verify <code><var>SIG_NAME</var></code>.iso.sig <code><var>ISO_NAME</var></code>.iso</code>
* Install the ISO to a drive: <code>cat <code><var>ISO_NAME</var></code>.iso > /dev/<code><var>DRIVE_LOCATION</var></code></code>

### Configure the BIOS
* Use UEFI boot mode
  > 📝 **Note:** UEFI is the newest standard and most modern hardware do not support legacy BIOS boot.
* Disable secure boot
  > 📝 **Note:** The Arch Linux installation images do not support secure boot. Secure boot can be set up after installation.

### Enter the live environment
* Boot into the installation medium
* Log in using username <code>artix</code> and password <code>artix</code>

### Partition the disks
* Use fdisk: <code>fdisk /dev/<code><var>DISK_NAME</var></code></code>
* Delete all existing partitions and signatures
  > ⚠️ **Warning:** This will wipe out the entire drive.
* Create a new empty GPT partition table
  > 📝 **Note:** GPT is the latest and recommended standard allowing more partitions and handles larger disk sizes.
* Create a 550M EFI System
  > 📝 **Note:** The author of gdisk suggests 550M.
* Create a 30G Linux Swap
  > 📝 **Note:** The rule of thumb is 2xRAM for hibernation.
* Create a 30G Linux root (x86-64)
  > 📝 **Note:** 15G is the recommended minimum, so 30G should be enough.
* Create the rest for Linux home

### Format the partitions
* Format the boot partition: <code>mkfs.fat -F 32 /dev/<code><var>BOOT_PARTITION</var></code></code>
  > 📝 **Note:** The EFI system partition must be formatted as FAT32 on UEFI systems.
* Set the boot partition label name: <code>fatlabel /dev/<code><var>BOOT_PARTITION</var></code> BOOT</code>
  > 💡 **Tip:** Assigning labels to partitions helps referring to them later without their numbers. \
  > 📝 **Note:** FAT volume labels are stored in uppercase, and warns that lowercase labels may not work on some systems.
* Create the swap partition: <code>mkswap -L SWAP /dev/<code><var>SWAP_PARTITION</var></code></code>
  > 💡 **Tip:** May need to remove any existing swap partitions in advance: <code>swapoff -a</code>.
* Format the root partition: <code>mkfs.ext4 -L ROOT /dev/<code><var>ROOT_PARTITION</var></code></code>
  > 📝 **Note:** Ext4 is the fast, pure, and stable standard.
* Format the home partition: <code>mkfs.ext4 -L HOME /dev/<code><var>HOME_PARTITION</var></code></code>

### Mount the file systems
* Mount the root partition: <code>mount /dev/<code><var>ROOT_PARTITION</var></code> /mnt</code>
* Mount the boot partition: <code>mount --mkdir /dev/<code><var>BOOT_PARTITION</var></code> /mnt/boot</code>
* Mount the home partition: <code>mount --mkdir /dev/<code><var>HOME_PARTITION</var></code> /mnt/home</code>
* Enable the swap volume: <code>swapon /dev/<code><var>SWAP_PARTITION</var></code></code>

### Connect to the internet
* Enter the ConnMan CLI: <code>connmanctl</code>
  * Enable Wi-Fi: <code>enable wifi</code>
  * Scan for networks: <code>scan wifi</code>
  * Enable the agent: <code>agent on</code>
    > 📝 **Note:** Needed to enable entering a password.
  * List available networks: <code>services</code>
  * Connect to a network: <code>connect wifi_<code><var>NETWORK_NAME</var></code></code>
    > 💡 **Tip:** Network names can be tab-completed.
* Verify the connection: <code>ping artixlinux.org</code>

### Update the system clock
* Activate the NTP daemon: <code>dinitctl start ntpd</code>

### Install essential packages
*  Install the base system: <code>basestrap /mnt base base-devel dinit elogind-dinit linux linux-firmware</code>

### Generate the fstab
* Generate the fstab file: <code>fstabgen -U /mnt >> /mnt/etc/fstab</code>
  > 📝 **Note:** Using <code>-U</code> for UUIDs instaed of <code>-L</code> for labels is safer.

### Enter the system
* Change root into the system: <code>artix-chroot /mnt</code>

### Configure the system clock
* Set the time zone: <code>ln -sf /usr/share/zoneinfo/<code><var>REGION</var></code>/<code><var>CITY</var></code> /etc/localtime</code>
* Set the hardware clock: <code>hwclock --systohc</code>

### Configure the localization
* Install a text editor: <code>sudo pacman -S neovim</code>
* Uncomment <code>en_US.UTF-8 UTF-8</code> and other needed locales in <code>/etc/locale.gen</code>
* Generate the locales: <code>locale-gen</code>
* Create the locale configuration file <code>/etc/locale.conf</code>:
  <pre>
  LANG=en_US.UTF-8
  </pre>

### Configure the boot loader
* Install a boot manager and the microcode: <code>pacman -S efibootmgr intel-ucode</code>
  > 📝 **Note:** Use EFISTUB to boot the kernel directly without a bootloader. \
  > 📝 **Note:** The microcode package depends on the CPU manufacturer.
* Create a boot entry with hibernation on the swap partition: <code>efibootmgr --create --disk /dev/<code><var>DISK_NAME</var></code> --part <code><var>BOOT_PARTITION_NUMBER</var></code> --label "Artix Linux" --loader /vmlinuz-linux --unicode 'root=UUID=<code><var>ROOT_UUID</var></code> resume=UUID=<code><var>SWAP_UUID</var></code> rw quiet console=tty2 initrd=\\<code><var>CPU_MANUFACTURER</var></code>-ucode.img initrd=\initramfs-linux.img'</code>
  > 📝 **Note:** For example, if the boot partition is on <code>/dev/nvme0n1p1</code>, then the <code>DISK_NAME</code> is <code>nvme0n1</code> and the <code>PARTITION_NUMBER</code> is <code>1</code>. \
  > 📝 **Note:** Replace <code>CPU_MANUFACTURER</code> with <code>amd</code> or <code>intel</code>. \
  > 📝 **Note:** <code>console=tty2</code> redirects all boot messages to TTY 2. \
  > 💡 **Tip:** To find the UUIDs, run <code>lsblk -f</code>.
* Verify the entry was added properly: <code>efibootmgr --unicode</code>
* Set the boot order: <code>efibootmgr --bootorder <var>####</var>,<var>####</var> --unicode</code>

### Configure users
* Set the root password: <code>passwd</code>
* Add a new user: <code>useradd -m -G wheel <code><var>USERNAME</var></code></code>
  > 📝 **Note:** <code>-m</code> creates the user's home directory, <code>-G</code> adds the user to the group
* Assign a password: <code>passwd <code><var>USERNAME</var></code></code>

### Configure networking
* Create the hostname file <code>/etc/hostname</code>:
  <pre>
  <code><var>HOSTNAME</var></code>
  </pre>
  > 💡 **Tip:** Choose a hostname to identify the machine on a network.
* Add the entry to the hosts file <code>/etc/hosts</code>:
  <pre>
  127.0.0.1        localhost
  ::1              localhost
  127.0.1.1        <var>HOSTNAME</var>.localdomain  <var>HOSTNAME</var>
  </pre>
* Install a wireless daemon and a DNS framework: <code>pacman -S dinit-iwd openresolv</code>
  > 📝 **Note:** Iwd manages networking without a network manager, and aims to replace wpa_supplicant.
* Create the iwd configuration file <code>/etc/iwd/main.conf</code>:
  <pre>
  [General]
  EnableNetworkConfiguration=true

  [Network]
  EnableIPv6=true
  NameResolvingService=resolvconf
  </pre>
  > 📝 **Note:** <code>EnableNetworkConfiguration</code> allows networking through iwd directly without a network manager. \
  > 📝 **Note:** <code>resolvconf</code> is required using <code>openresolv</code> for DNS management and networking.
* Enable the networking service: <code>ln -s /etc/dinit.d/iwd /etc/dinit.d/boot.d/</code>

### Reboot
* Exit the chroot environment: <code>exit</code>
* Unmount the drive: <code>umount -R /mnt</code>
* Reboot the system: <code>reboot</code>

<br>

# Post-installation

### Connect to the internet
* Connect to the internet: <code>iwctl station <code><var>DEVICE</var></code> connect <code><var>SSID</var></code></code>
  > 💡 **Tip:** To find the device run: <code>iwctl device list</code>, and to find the SSID run: <code>iwctl station <code><var>DEVICE</var></code> get-networks</code>
* Verify the connection: <code>ping artixlinux.org</code>

### Enable privilege elevation
* Temporarily set the editor to use visudo: <code>export VISUAL=nvim</code>
* Open the configuration file: <code>visudo</code>
* Allow users in the <code>wheel</code> group to use <code>sudo</code> without a password by uncommenting the following line:
  <pre>
  %wheel ALL=(ALL:ALL) NOPASSWD: ALL
  </pre>

### Restrict root
* Restrict root login: <code>passwd --lock root</code>
* Require a user to be in the <code>wheel</code> group to use <code>su</code> by uncommenting the following line in <code>/etc/pam.d/su</code> and <code>/etc/pam.d/su-l</code>:
  <pre>
  auth required pam_wheel.so use_uid
  </pre>

### Deny SSH login
* Install openssh: <code>pacman -S openssh-dinit</code>
* Deny SSH login by uncommenting <code>PermitRootLogin</code> and changing <code>prohibit-password</code> to <code>no</code> in <code>/etc/ssh/sshd_config</code>:
  <pre>
  PermitRootLogin no
  </pre>

### Configure Pacman
* Uncomment the following configurations in <code>/etc/pacman.conf</code>:
  <pre>
  Color
  CheckSpace
  VerbosePkgLists
  ParallelDownloads = 5
  ILoveCandy
  </pre>
* Install pacman-contrib for pacman tools: <code>pacman -S pacman-contrib</code>
* Create a hook that finds all .pacnew and .pacsave files on upgrade:
  <pre>
  [Trigger]
  Operation = Upgrade
  Type = Package
  Target = *

  [Action]
  Description = Finding all .pacnew and .pacsave files
  When = PostTransaction
  Depends = pacman-contrib
  Exec = /bin/sh -c "pacdiff -o"
  </pre>

### Configure mirrors
* Install artix-archlinux-support for Arch Linux packages: <code>pacman -S artix-archlinux-support</code>
  > 📝 **Note:** This is needed because many common Arch Linux packages are missing from the Artix Linux repositories.
* Add the Arch Linux mirrorlists **after** the Artix Linux mirrorlists in <code>/etc/pacman.conf</code>:
  <pre>
  [extra]
  Include = /etc/pacman.d/mirrorlist-arch

  [multilib]
  Include = /etc/pacman.d/mirrorlist-arch
  </pre>
  > ⚠️ **Important:** The Arch mirrorlists must be listed after the Artix mirrorlists so that the Artix packages take precedence.
* Update the keyring for Arch packages: <code>pacman-key --populate archlinux</code>
* Back up the mirrorlists: <code>cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup && cp /etc/pacman.d/mirrorlist-arch /etc/pacman.d/mirrorlist-arch.backup</code>
* Create a hook to rank mirrors on artix-mirrorlist update in <code>/etc/pacman.d/hooks/rankmirrors.hook</code>:
  <pre>
  [Trigger]
  Operation = Upgrade
  Type = Package
  Target = artix-mirrorlist

  [Action]
  Description = Ranking artix-mirrorlist by speed
  When = PostTransaction
  Depends = pacman-contrib
  Exec = /bin/sh -c "cp -f /etc/pacman.d/mirrorlist.pacnew /etc/pacman.d/mirrorlist.backup && sed -i -e 's/^#Server/Server/' -e /^#/d' /etc/pacman.d/mirrorlist.pacnew && rankmirrors /etc/pacman.d/mirrorlist.pacnew > /etc/pacman.d/mirrorlist && rm /etc/pacman.d/mirrorlist.pacnew"
  </pre>
* Create a hook to rank mirrors on archlinux-mirrorlist update in <code>/etc/pacman.d/hooks/rankmirrors-arch.hook</code>:
  <pre>
  [Trigger]
  Operation = Upgrade
  Type = Package
  Target = archlinux-mirrorlist

  [Action]
  Description = Ranking archlinux-mirrorlist by speed
  When = PostTransaction
  Depends = pacman-contrib
  Exec = /bin/sh -c "cp -f /etc/pacman.d/mirrorlist-arch.pacnew /etc/pacman.d/mirrorlist-arch.backup && sed -i -e 's/^#Server/Server/' -e '/^#/d' /etc/pacman.d/mirrorlist-arch.pacnew && rankmirrors /etc/pacman.d/mirrorlist-arch.pacnew > /etc/pacman.d/mirrorlist-arch && rm /etc/pacman.d/mirrorlist-arch.pacnew"
  </pre>

### Configure Makepkg
* Automatically detect and enable safe architecture-specific optimizations in <code>/etc/makepkg.conf</code>:
  * Remove any <code>-march</code> and <code>-mtune</code> C flags
  * Add the <code>-march=native</code> C flag:
    <pre>
    CFLAGS="-march=native ..."
    </pre>
  * Uncomment the Rust flags
  * Add the <code>-C target-cpu=native</code> Rust flag:
    <pre>
    RUSTFLAGS="-C opt-level=2 -C target-cpu=native"
    </pre>
  * Uncomment the Make flags
  * Use parallel compilation by replacing the Make flag <code>-j2</code> with <code>-j$(nproc)</code>:
    <pre>
    MAKEFLAGS="-j$(nproc)"
    </pre>
  * Use multiple cores on compression by adding <code>--threads=0</code> to XZ and Zstandard:
    <pre>
    COMPRESSXZ=(xz -c -z --threads=0 -)
    COMPRESSZST=(zstd -c -z -q --threads=0 -)
    </pre>

### Install an AUR helper
* Install Git: <code>pacman -S git-dinit</code>
* Clone Paru: <code>git clone https://aur.archlinux.org/paru.git</code>
  > 📝 **Note:** Paru is the latest AUR helper and a Rust rewrite of Yay.
* Build Paru: <code>cd paru/ && makepkg -sir</code>
* Remove the directory: <code>cd ../ && rm -rf paru</code>

### Install the remaining packages
* Install the remaining packages: <code>TODO</code>
* Copy the configuration files: <code>TODO</code>

<br>

# Packages
List all installed packages that are not strict dependencies of other packages: <code>pacman -Qtt</code>

| Package                 | Justification                                                                                                          |
| ----------------------- | ---------------------------------------------------------------------------------------------------------------------- |
| artix-archlinux-support | Enables installing Arch Linux packages. Many common Arch Linux packages are missing from the Artix Linux repositories. |
| base                    | Tools to install Artix Linux.                                                                                          |
| base-devel              | Tools to build Artix Linux packages.                                                                                   |
| efibootmgr              | Boots Linux without a bootloader by loading the kernel directly.                                                       |
| foot                    | Terminal emulator.                                                                                                     |
| git-dinit               | Manages version control.                                                                                               |
| intel-ucode             | Updates the firmware for system stability.                                                                             |
| iwd-dinit               | Manages networking without a full network manager.                                                                     |
| linux                   | Linux kernel.                                                                                                          |
| linux-firmware          | Linux firmware.                                                                                                        |
| man-db                  | Reads man pages.                                                                                                       |
| neovim                  | Text editor.                                                                                                           |
| openssh                 | Allows remote login with SSH.                                                                                          |
| pacman-contrib          | Checks for updates, ranks mirrors, and manages .pacnew and .pacsave files.                                             |
| paru                    | Installs packages from the Arch User Repository.                                                                       |
| polkit                  | Manages elevated permissions to run Wayland.                                                                           |
| river                   | Window manager.                                                                                                        |
| ungoogled-chromium      | Web browser. A spyware-free chromium engine. Install using pipewire-jack and wireplumber, the latest standards.        |

\* AUR packages
