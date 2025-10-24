# Cheat sheet

## Pacman

### Upgrade all packages
* <code>pacman -Syu</code>

### Install a package
* <code>pacman -S <code><var>PACKAGE</var></code></code>

### Uninstall a package
* <code>pacman -Rns <code><var>PACKAGE</var></code></code>

### List all packages that are not direct dependencies (includes optional dependencies)
* <code>pacman -Qtt</code>

## GnuPG

### Create keys
* <code>gpg --full-generate-key</code>
* <code>gpg --edit-key --expert <code><var>KEY_ID</var></code></code>
    * <code>addkey</code>
    * <code>ECC (set your own capabilities)</code>
    * <code>Toggle the authenticate capability</code>
    * <code>Toggle the sign capability</code>
    * <code>Finished</code>
* <code>echo <code><var>KEY_GRIP</var></code> > "${GNUPGHOME}/sshcontrol"</code>
    > 💡 **Tip**: The key grip can be found by running: <code>gpg --list-keys --with-keygrip</code> \
    > 📝 **Note**: This is needed to use the GPG key as the SSH key.

### Export keys
* <code>gpg --export --output public.key <code><var>KEY_ID</var></code></code>
* <code>gpg --export-secret-key --output secret.key <code><var>KEY_ID</var></code></code>
* <code>gpg --export-ownertrust > trust.txt</code>
* <code>gpg --gen-revoke --output revoke.key <code><var>KEY_ID</var></code></code>
* <code>gpg --export-ssh-key <code><var>KEY_ID</var></code></code>
    > 📝 **Note**: This exports the SSH public key. \
    > 📝 **Note**: This sub-key is automatically imported when the main key is imported.

### Import keys
* <code>gpg --import public.key</code>
* <code>gpg --import secret.key</code>
* <code>gpg --import-ownertrust trust.txt</code>

### Revoke keys
* <code>gpg --import revoke.key</code>

## Storage

### Archive a file
* <code>tar --create --file="<code><var>FILE</var></code>.tar.xz" --xattrs --xattrs-include="*" --xz <code><var>FILE</var></code></code>
* <code>gpg --cipher-algo AES256 --output <code><var>FILE</var></code>.tar.xz.gpg --symmetric <code><var>FILE</var></code>.tar.xz</code>

### Unarchive a file
* <code>gpg --decrypt --output <code><var>FILE</var></code>.tar.xz <code><var>FILE</var></code>.tar.xz.gpg</code>
* <code>tar --extract --file="<code><var>FILE</var></code>.tar.xz" --xattrs --xattrs-include="*" --xz</code>

## Networking

### Get the device name
* <code>iwctl device list</code>

### List all networks
* <code>iwctl station <code><var>DEVICE</var></code> get-networks</code>

### Connect to a network
* <code>iwctl station <code><var>DEVICE</var></code> connect <code><var>SSID</var></code></code>

### Disconnect from a network
* <code>iwctl station <code><var>DEVICE</var></code> disconnect</code>

### List known networks
* <code>iwctl known-networks list</code>

### Forget a network
* <code>iwctl known-netowkrs <code><var>SSID</var></code> forget</code>

## Bluetooth

### List all devices
* <code>bluetoothctl</code>
    * <code>scan on</code>
    * <code>devices</code>

### Connect to a device
* <code>bluetoothctl</code>
    * <code>pair <code><var>MAC_ADDRESS</var></code></code>
    * <code>trust <code><var>MAC_ADDRESS</var></code></code>
    * <code>connect <code><var>MAC_ADDRESS</var></code></code>
 
### Disconnect from a device
* <code>bluetoothctl</code>
    * <code>disconnect <code><var>MAC_ADDRESS</var></code></code>
 
### Forget a device
* <code>bluetoothctl</code>
    * <code>remove <code><var>MAC_ADDRESS</var></code></code>

## Graphics

### Run a program with the dedicated GPU
* <code>DRI_PRIME=1 <code><var>COMMAND</var></code></code>
    > 📝 **Note**: System must be set to hybrid mode: <code>sudo envycontrol -s hybrid</code>
