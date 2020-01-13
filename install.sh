#!/bin/bash

# An installation script for setting up the Arch Linux environment.

# Set up new user.
createUser() {
  echo "Setting up new user..."
  read -rp "Enter username: " user
  while ! useradd -m -g wheel "$user";  do
    read -rp "Enter username: " user
  done
  while ! passwd "$user"; do
    echo "Try again"
  done
  echo -e "New user set up!\n"
}

# Install packages.
installPackages() {
  local pacmanPackages="alacritty base base-devel bash-completion \
      bash-language-server blueman clang dunst feh firefox gdb git grub \
      i3-gaps i3blocks i3lock imagemagick linux linux-firmware man-db neovim \
      net-tools network-manager-applet nodejs noto-fonts noto-fonts-emoji \
      openssh pacman-contrib pamixer picom pulseaudio-bluetooth reflector \
      ripgrep rofi scrot shellcheck texlab texlive-most valgrind xclip \
      xf86-video-intel xorg-server xorg-xbacklight xorg-xinit xorg-xset \
      xss-lock zathura-pdf-mupdf"
  local yayPackages="bear simple-mtpfs"

  echo "Updating and installing packages..."
  pacman -Syu
  pacman -S "$pacmanPackages"

  sudo -u "$user" mkdir -v "/home/$user/programs/"
  sudo -u "$user" git clone "https://aur.archlinux.org/yay.git" \
      "/home/$user/programs/yay/"
  cd "/home/$user/programs/yay/" || exit 1
  sudo -u "$user" makepkg -si
  cd /root || exit 1
  sudo -u "$user" yay -Syu
  sudo -u "$user" yay -S "$yayPackages"
  echo -e "Packages updated and installed!\n"
}

# Update permissions.
updatePermissions() {
  echo "Giving wheel group sudo access..."
  sed -i "s/^# %wheel ALL=(ALL) NOPASSWD: ALL/%wheel ALL=(ALL) NOPASSWD: ALL/" \
      "/etc/sudoers"
  echo "Disabling local root login..."
  passwd -l "root"
  echo "Disabling ssh root login..."
  sed -i "s/^#PermitRootLogin prohibit-password/PermitRootLogin No/" \
      "/etc/ssh/sshd_config"
  echo -e "Local and ssh root login disabled!\n"
}

# Update Pacman mirror list.
updateMirrorList() {
  hook="[Trigger]\nOperation = Upgrade\nType = Package\n\
Target = pacman-mirrorlist\n\n[Action]\nDescription = \
Updating pacman-mirrorlist with reflector and removing pacnew...\n\
When = PostTransaction\nDepends = reflector\nExec = /bin/sh -c \
\"reflector --latest 200 --protocol http --protocol https --sort rate \
--save /etc/pacman.d/mirrorlist; rm -f /etc/pacman.d/mirrorlist.pacnew\""
  echo "Creating mirror list backup..."
  cp -fv "/etc/pacman.d/mirrorlist" "/etc/pacman.d/mirrorlist.backup"
  echo "Creating hook..."
  mkdir -v "/etc/pacman.d/hooks/"
  echo -e "$hook" >> "/etc/pacman.d/hooks/mirrorupgrade.hook"
  echo "Updating mirror list..."
  reflector --latest 200 --protocol "http" --protocol "https" --sort "rate" \
      --save "/etc/pacman.d/mirrorlist"
  echo -e "Mirror list updated!\n"
}

# Configure Pacman options.
configurePacman() {
  echo "Enabling Pacman color..."
  sed -i "s/^#Color/Color/" "/etc/pacman.conf"
  echo "Enabling Pacman total download percentage..."
  sed -i "s/^#TotalDownload/TotalDownload/" "/etc/pacman.conf"
  echo "Enabling Pacman disk space check before installing..."
  sed -i "s/^#CheckSpace/CheckSpace/" "/etc/pacman.conf"
  echo "Enabling Pacman loading bar..."
  sed -i "/^# Misc options/a ILoveCandy" "/etc/pacman.conf"
  echo -e "Pacman options configured!\n"
}

# Configure NetworkManager options.
configureNetworkManager() {
  echo "Configuring NetworkManager..."
  # Allows NetworkManager to reconnect after disconnecting.
  echo -e "\n[device]\nwifi.scan-rand-mac-address=no" \
      >> "/etc/NetworkManager/NetworkManager.conf"
  echo -e "NetworkManager configured!\n"
}

# Hide GRUB menu unless Shift key held down.
hideGRUB() {
  echo "Installing GRUB..."
  disk="DISK_NAME_HERE"
  while ! fdisk -l | grep $disk >> /dev/null; do
    read -rp "Enter the disk where GRUB is to be installed (Ex. /dev/sda (NOT /dev/sda1)): " disk
  done
  grub-install --target=i386-pc "$disk"
  echo "Hiding GRUB menu unless Shift key held down..."
  echo -e "\n# Hide GRUB menu unless Shift key held down\
      \nGRUB_FORCE_HIDDEN_MENU=\"true\"" >> "/etc/default/grub"
  curl "https://gist.githubusercontent.com/anonymous/8eb2019db2e278ba99be/raw/257f15100fd46aeeb8e33a7629b209d0a14b9975/gistfile1.sh" \
      -o "/etc/grub.d/31_hold_shift"
  chmod -v +x "/etc/grub.d/31_hold_shift"
  grub-mkconfig -o "/boot/grub/grub.cfg"
  echo -e "GRUB menu hidden unless Shift key held down!\n"
}

# Enable parallel compilation and compression.
enableMultithreading() {
  echo "Optimizing compilation..."
  sed -i "s/^#MAKEFLAGS=\"-j2\"/MAKEFLAGS=\"-j\$(nproc)\"/" "/etc/makepkg.conf"
  echo "Optimizing XZ compression..."
  sed -i "s/^COMPRESSXZ=(xz -c -z -)/COMPRESSXYZ=(xz -c -z - --threads=0)/" \
      "/etc/makepkg.conf"
  echo "Optimizing ZST compression..."
  sed -i "s/^COMPRESSZST=(zstd -c -z -q -)/COMPRESSZST=(zstd -c -z -q - --threads=0)/"\
      "/etc/makepkg.conf"
  echo -e "Parallel compilation and compression enabled!\n"
}

# Copy files from repository.
copyRepo() {
  echo "Copying files from repo..."
  sudo -u "$user" git clone "https://github.com/JoshuaHong/env.git" \
      "/home/$user/env/"
  sudo -u "$user" cp -rv "/home/$user/env/." "/home/$user/"
  rm -rfv "/home/$user/env/" "/home/$user/.git" "/home/$user/install.sh" \
      "/home/$user/README.md" "/home/$user/.cache/*"
  echo -e "Files copied from repo!\n"
}

# Install Neovim plugins.
installNeovimPlugins() {
  echo "Installing Neovim plugins..."
  sudo -u "$user" curl -fLo ~/.local/share/nvim/site/autoload/plug.vim \
      --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  sudo -u "$user" nvim +PlugUpgrade +PlugInstall +qall
  echo -e "Installed Neovim plugins!\n"
}

# Check for root access.
if [[ "$EUID" -ne 0 ]]; then
   echo "ERROR: This script must be run as root"
   exit 1
fi

# Run installation.
echo -e "Starting installation...\n"
createUser
installPackages
updatePermissions
updateMirrorList
configurePacman
configureNetworkManager
hideGRUB
enableMultithreading
copyRepo
installNeovimPlugins
echo -e "DONE!\n"

echo "TODO:"
echo "  1. Install Firefox plugins: Tabliss, uBlock Origin, Vimium-FF"
echo "  2. Add \"mapkey <C-/> <c-[>\" to Vimium's \"Custom key mappings\""
echo "  3. Download [PIA VPN](https://www.privateinternetaccess.com/installer/x/download_installer_linux) and enable \"Connect on Launch\""
echo "  4. Reboot"
