Setup:
Create new user:
  1. useradd -m -g wheel josh
  2. passwd josh
  3. Edit /etc/sudoers by uncommenting: %wheel ALL=(ALL) NOPASSWD: ALL
Disable local and ssh root login:
  1. Run: passwd -l root 
  2. Edit PermitRootLogin in /etc/ssh/sshd_config to: PermitRootLogin no
Optimize compression and compilation threads:
  1. Edit COMPRESSXYZ in /etc/makegkg.conf to: COMPRESSXZ=(xz -c -z - --threads=0)
  2. Edit MAKEFLAGS in /etc/makepkg.conf to: MAKEFLAGS="-j$(nproc)"
Hide GRUB menu unless Shift key held down:
  1. In /etc/default/grub add: GRUB_FORCE_HIDDEN_MENU="true"
  2. Create the script: /etc/grub.d/31_hold_shift
  3. Make it executable: chmod a+x /etc/grub.d/31_hold_shift
  4. Regenerate the grub configuration: grub-mkconfig -o /boot/grub/grub.cfg
Fix Firefox graphics:
  1. Open Firefox about:config page
  2. Set layers.acceleration.force-enabled true
Vim setup:
  1. Install vim plug
  2. :PlugUpgrade && :PlugInstall

Useful commands:
pacman -Syu                     // Update and upgrade installed packages
pacman -Qtt                     // List installed non-required packages
pacman -Rns $(pacman -Qtdq)     // Remove orphans
pacman -Sc                      // Remove uninstalled package caches

Packages (42):
alacritty                       // Terminal emulator                          // For running terminal
alsa-utils                      // Audio controls                             // For volume controls
autoconf                        // Automatically configures source code       // For base-devel
automake                        // Automatically creating make files          // For base-devel
base                            // Base packages                              // For arch install
bison                           // Parser generator                           // For base-devel
compton                         // Compositor                                 // For transparency
dmenu                           // Menu bar                                   // For searching programs
dunst                           // Notification daemon                        // For displaying notifications
fakeroot                        // Simulating superuser privileges            // For base-devel
feh                             // Image viewer                               // For setting wallpaper
firefox                         // Browser                                    // For browsing internet
flex                            // Generates text scanning programs           // For base-devel
gcc                             // GNU compiler collection                    // For base-devel
grub                            // Bootloader                                 // For loading Linux kernel
gvim                            // Text editor                                // For editing text
i3-gaps                         // Window manager                             // For managing windows
i3blocks                        // Status bar                                 // For displaying status
i3lock                          // Lock screen                                // For locking screen
imagemagick                     // Image editor                               // For editing lockscreen
linux                           // Linux kernel                               // For running Linux
linux-firmware                  // Linux firmware                             // For running Linux
make                            // GNU make utility                           // For base-devel
man-db                          // Man pages                                  // For reading program manuals
net-tools                       // Networking tools                           // For Pia Vpn
network-manager-applet          // System tray for NetworkManager             // For Network Manager applet
noto-fonts-emoji                // Font for emoji symbols                     // For rendering unicode symbols
openssh                         // Ssh                                        // For ssh
patch                           // Patches files                              // For base-devel
pkgconf                         // Package compiler and linker                // For base-devel
ripgrep                         // Grep tool                                  // For searching files
scrot                           // Screen capture                             // For taking screenshotr
simple-mtpfs *                  // Media transfer protocol file system        // For mounting mobile phones
ttf-symbola *                   // Font for unicode symbols                   // For rendering unicode on dmenu
which                           // Show full path of commands                 // For base-devel
xclip                           // Manipulates X11 clipboard                  // For copying unicode to clipboard
xf86-video-intel                // XOrg video driver                          // For graphics display
xorg-server                     // XOrg package                               // For running X
xorg-xbacklight                 // Screen brightness                          // For brightness controls
xorg-xinit                      // XOrg initialisation                        // For startx
xorg-xset                       // Set lock timeout                           // For setting dim and lock screen timeouts
xss-lock                        // Use external locker                        // For locking screen
yay *                           // AUR package manager                        // For installing AUR packages

* = AUR packages
