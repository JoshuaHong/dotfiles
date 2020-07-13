# dotfiles
Setup for the Arch Linux environment

### Pre-installation

##### BIOS configuration
* Ensure BIOS boot mode is set to UEIF (for systemd-boot)
* Ensure BIOS SATA operation is set to AHCI (for visible disk partitions)

##### Connect to the internet
* Use netctl: `wifi-menu`

##### Partition the disks
* Use fdisk: `fdisk /dev/nvme0n1`
* Delete all partitions
* Create a new empty GPT partition table
* Create a new 512M EFI System
* Create a new 220G Linux Filesystem
* Create a new 18G Linux Swap

##### Format the partitions
* Format the boot partition: `mkfs.fat -F32 /dev/nvme0n1p1`
* Format the main partition: `mkfs.ext4 /dev/nvme0n1p2`
* Create the swap partition: `mkswap /dev/nvme0n1p3`
* Enable the swap partition: `swapon /dev/nvme0n1p3`

##### Mount the file systems
* Mount the main file system: `mount /dev/nvme0n1p2 /mnt`
* Create the boot mount point: `mkdir /mnt/boot`
* Mount the boot file system: `mount /dev/nvme0n1p1 /mnt/boot`

### Installation

##### Install essential packages
* Install a text editor and a network manager: `pacstrap /mnt neovim networkmanager`
* Enable the Network Manager service: `systemctl enable NetworkManager.service`

##### Boot loader
* Install systemd-boot: `bootctl --path=/boot install`
* Create a Pacman hook for automatic updates in `/etc/pacman.d/hooks/100-systemd-boot.hook`:
```
[Trigger]
Type = Package
Operation = Upgrade
Target = systemd

[Action]
Description = Updating systemd-boot
When = PostTransaction
Exec = /usr/bin/bootctl update
```
* Edit the loader configuration file `/boot/loader/loader.conf`:
```
default    arch-*
```
* Create the arch configuration file `/boot/loader/entries/arch.conf`:
<pre>
title    Arch Linux
linux    /vmlinuz-linux
initrc   /initramfs-linux.img
options  root=UUID=<em>UUID</em> rw
</pre>

\* To find *UUID* in vim run `:r! blkid`

##### Reboot
* Exit the chroot environment: `exit`
* Unmount all partitions: `umount -R /mnt`
* Restart the machine: `reboot`

### Post-installation

##### Keyboard configuration
* Copy the Linux console keymap from `env/keymaps/colemak-mod-dh.map` to `/usr/share/kbd/keymaps/i386/colemak/colemak-mod-dh.map`
* Set the Linux console keymap in `/etc/vconsole.conf`:
```
KEYMAP=/usr/share/kbd/keymaps/i386/colemak/colemak-mod-dh.map
```
* Copy the Xorg keymap from `env/keymaps/us` to `/usr/share/X11/xkb/symbols/us`
* Add the Xorg keymap to `/usr/share/X11/xkb/rules/xorg.xml` as a us variant:
```
...
<variant>
  <configItem>
    <name>colemak-mod-dh</name>
    <description>English (Colemak Mod-DH)</description>
  </configItem>
</variant>
...
```
* Add the Xorg keymap to `/usr/share/X11/xkb/rules/xorg.lst` as a variant:
```
...
colemak-mod-dh  us: English (Colemak Mod-DH)
...
```
* Set the Xorg keymap: `localectl --no-convert set-x11-keymap us "" colemak-mod-dh ctrl:swap_lalt_lctl`

##### Users and groups
* Create the main user: `useradd -m -G wheel josh`
* Set up the user password: `passwd josh`
* Disable root login: `passwd -l root`

##### Configure Pacman
* In `/etc/pacman.conf` misc options uncomment the following:
```
...
Color
TotalDownload
CheckSpace
ILoveCandy
...
```

##### Enable parallel compilation and compression
* Edit `/etc/makepkg.conf`:
```
...
MAKEFLAGS="-j$(nproc)"
...
COMPRESSXZ=(xz -c -z - --threads=0)
COMPRESSZST=(zstd -c -z -q - --threads=0)
...
```

##### Add global environment variables
* At the bottom of `etc/profile` export the following:
```
# XDG base directory
export XDG_DATA_DIRS="/usr/local/share:/usr/share"
export XDG_CONFIG_DIRS="/etc/xdg"
```

##### Copy files
* Copy files as user: `su josh`
* Change directory: `cd`
* Clear the directory: `rm -rf *`
* Clone this directory: `git clone https://github.com/JoshuaHong/dotfiles.git`
* Copy files to home: `cp -r .bash_profile .bashrc .cache .config downloads images .local .profile programs`
* Remove .gitkeep files: `find . -type f -name ".gitkeep" -exec rm -f {} \;`
* Remove this directory: `rm -rf dotfiles`

##### Install and configure packages
* Reflector:
  * Install Reflector `pacman -S reflector`
  * Create a copy of the Pacman mirrorlist: `cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup`
  * Update the Pacman mirrorlist: `reflector --country Canada --latest 200 --age 24 --sort rate --save /etc/pacman.d/mirrorlist`
  * Create a Pacman hook for automatic updates:
  ```
  [Trigger]
  Operation = Upgrade
  Type = Package
  Target = pacman-mirrorlist

  [Action]
  Description = Updating pacman-mirrorlist with reflector and removing pacnew...
  When = PostTransaction
  Depends = reflector
  Exec = /bin/sh -c "reflector --country Canada --latest 200 --age 24 --sort rate --save /etc/pacman.d/mirrorlist; rm -f /etc/pacman.d/mirrorlist.pacnew"
  ```
* Install remaining Pacman packages: `pacman -S ***** TODO *****`
* Sudo:
  * Install Sudo: `pacman -S sudo`
  * To allow wheel group sudo access, in `/etc/sudoers` uncomment:
  ```
  ...
  %WHEEL ALL=(ALL) NOPASSWD: ALL
  ...
  ```
* Openssh:
  * Install Openssh: `pacman -S openssh`
  * To disable root login over ssh, in `/etc/ssh/sshd_config` edit:
  ```
  ...
  PermitRootLogin No
  ...
  ```
* Dwm:
  * Build as user: `su josh`
  * Clone Dwm: `git clone https://github.com/JoshuaHong/dwm.git $HOME/.local/src/dwm`
  * Change directory: `cd $HOME/.local/src/dwm`
  * Build package: `sudo make install clean`
  * Set upstream: `git remote set-url --push origin https://github.com/JoshuaHong/dwm.git`
* St:
  * Build as user: `su josh`
  * Clone St: `git clone https://github.com/JoshuaHong/st $HOME/.local/src/st`
  * Change directory: `cd $HOME/.local/src/st`
  * Build package: `sudo make install clean`
  * Set upstream: `git remote set-url --push origin https://github.com/JoshuaHong/st.git`
* Yay:
  * Build as user: `su josh`
  * Clone Yay: `git clone https://aur.archlinux.org/yay.git $HOME/.local/src/yay`
  * Change directory: `cd $HOME/.local/src/yay`
  * Build package: `makepkg -si`
  * Install yay packages: `yay -S @@@@@@ TODO @@@@@@`
* Neovim:  
  * Install Neovim Plugins: nvim +PlugUpgrade +PlugInstall +qall
* Network Manager ?? :
<!--
  # Allows NetworkManager to reconnect after disconnecting.
  echo -e "\n[device]\nwifi.scan-rand-mac-address=no" \
      >> "/etc/NetworkManager/NetworkManager.conf"
-->

##### Reboot
Restart the machine: `reboot`

### Dell XPS 13

##### PSMouse Error
If `dmesg | grep -i psmouse` returns an error, but the touchpad still works:
* Create a config file `/etc/modprobe.d/modprobe.conf`:
```
blacklist psmouse
```
* Add this file to `/etc/mkinitcpio.conf`:
```
...
FILES=(/etc/modprobe.d/modprobe.conf)
...
```
* Create a new initramfs: `mkinitpcio -P`

##### PCIe Bus Error
If `dmesg | grep -i pcieport` returns an error such as:
```
   @@@@@ TODO @@@@@
   and fix other dmesg errors
```

### Suckless

##### Patching
* Checkout master branch: `git checkout master`
* Checkout patch branch: `git checkout -b patch`
* Apply the patch: `git apply patch.diff`
* Add the patch: `git add .`
* Commit the patch: `git commit -m "Add patch"`
* Push the patch: `git push`
* Checkout develop branch: `git checkout develop`
* Merge the patch: `git merge patch`
* Push the patch: `git push`

##### Rebasing
* Checkout master branch: `git checkout master`
* Pull updates: `git pull`
* Checkout branch: `git checkout develop`
* Rebase branch: `git rebase --preserve-merges master`
* Fix conflicts: `git mergetool`
* Add resolved conflicts: `git add resolved_file.ext`
* Continue rebasing: `git rebase --continue`
* Push the update: `git push`
* Repeat for all branches


### Packages (66):
| Package                | Description                            | Function                                 |
| ---------------------- | -------------------------------------- | ---------------------------------------- |
| alacritty              | Terminal emulator                      | For running terminal                     |
| autoconf               | Automatically configures source code   | For Yay dependency (base-devel)          |
| automake               | Automatically creating make files      | For Yay dependency (base-devel)          |
| base                   | Base packages                          | For Arch install                         |
| bash-completion        | Completion for the Bash shell          | For smart tab completion                 |
| bash-language-server   | Bash language server implementation    | For Bash language server protocol        |
| bear *                 | Clang compilation database generator   | For ALE and COC Makefile reader          |
| bison                  | Parser generator                       | For Yay dependency (base-devel)          |
| blueman                | Bluetooth manager                      | For configuring Bluetooth                |
| clang                  | C family compiler                      | For Clangd language server protocol      |
| dunst                  | Notification daemon                    | For displaying notifications             |
| feh                    | Image viewer                           | For setting background                   |
| firefox                | Browser                                | For browsing Internet                    |
| flex                   | Generates text scanning programs       | For Yay dependency (base-devel)          |
| gdb                    | GNU debugger                           | For debugging                            |
| grub                   | Bootloader                             | For loading Linux kernel                 |
| i3-gaps                | Window manager                         | For managing windows                     |
| i3blocks               | Status bar                             | For displaying status                    |
| i3lock                 | Lock screen                            | For locking screen                       |
| imagemagick            | Image editor                           | For editing lockscreen                   |
| linux                  | Linux kernel                           | For running Linux                        |
| linux-firmware         | Linux firmware                         | For running Linux                        |
| make                   | GNU make utility                       | For Yay dependency (base-devel)          |
| man-db                 | Man pages                              | For reading program manuals              |
| neovim                 | Text editor                            | For editing text                         |
| net-tools              | Networking tools                       | For PIA VPN dependency                   |
| network-manager-applet | System tray for NetworkManager         | For Network Manager applet               |
| noto-fonts-emoji       | Font for emoji symbols                 | For rendering unicode symbols            |
| npm                    | JavaScript package manager             | For COC dependency                       |
| openssh                | SSH protocol                           | For SSH                                  |
| pacman-contrib         | Scripts and tools for Pacman systems   | For checkupdates                         |
| pamixer                | PulseAudio command-line mixer          | For audio controls                       |
| patch                  | Patches files                          | For Yay dependency (base-devel)          |
| picom                  | Compositor                             | For transparency                         |
| pkgconf                | Package compiler and linker            | For Yay dependency (base-devel)          |
| pulseaudio-bluetooth   | Bluetooth support for PulseAudio       | For supporting Bluetooth audio devices   |
| reflector              | Retrieve and filter Pacman mirror list | For updating Pacman mirror list          |
| ripgrep                | Grep tool                              | For searching files                      |
| rofi                   | Menu bar                               | For selecting options                    |
| scrot                  | Screen capture                         | For taking screenshots                   |
| shellcheck             | Shell script analysis tool             | For ALE shell script linting             |
| simple-mtpfs *         | Media transfer protocol file system    | For mounting mobile phones               |
| texlab                 | LaTeX language server protocol         | For LaTeX language server protocol       |
| texlive-bibtexextra    | TeX Live bibliographies                | For LaTeX dependency (texlive-most)      |
| texlive-fontsextra     | TeX Live extra fonts                   | For LaTeX dependency (texlive-most)      |
| texlive-formatsextra   | TeX Live extra formats                 | For LaTeX dependency (texlive-most)      |
| texlive-games          | TeX Live board games                   | For LaTeX dependency (texlive-most)      |
| texlive-humanities     | TeX Live humanities                    | For LaTeX dependency (texlive-most)      |
| texlive-music          | TeX Live music                         | For LaTeX dependency (texlive-most)      |
| texlive-pictures       | TeX Live pictures                      | For LaTeX dependency (texlive-most)      |
| texlive-pstricks       | TeX Live PSTricks                      | For LaTeX dependency (texlive-most)      |
| texlive-publishers     | TeX Live publishers                    | For LaTeX dependency (texlive-most)      |
| texlive-science        | TeX Live science                       | For LaTeX dependency (texlive-most)      |
| valgrind               | Memory management tool                 | For catching memory leaks                |
| which                  | Show full path of commands             | For Yay dependency (base-devel)          |
| xclip                  | Manipulates X11 clipboard              | For copying unicode, Neovim copy on exit |
| xdotool                | X11 automation tool                    | For closing viewers on Neovim exit       |
| xf86-video-intel       | Xorg video driver                      | For graphics display                     |
| xorg-server            | Xorg package                           | For running X11                          |
| xorg-xbacklight        | Screen brightness                      | For brightness controls                  |
| xorg-xinit             | Xorg initialisation                    | For startx                               |
| xorg-xset              | Set lock timeout                       | For setting dim and lock screen timeouts |
| xss-lock               | Use external locker                    | For locking screen                       |
| yay *                  | AUR package manager                    | For installing AUR packages              |
| zathura-pdf-mupdf      | PDF support for Zathura                | For viewing LaTeX previews               |

\* = AUR packages
