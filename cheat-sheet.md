# Cheat sheet

## Pacman

### Upgrade packages
* Sync and upgrade packages: <code>pacman -Syu</code>
* Update ".pacnew" files: <code>pacdiff -s</code>
    > 📝 **Note**: Use sudo to manage the files.

### Install packages
* Install a package: <code>pacman -S <code><var>PACKAGE</var></code></code>

### Uninstall packages
* Uninstall a package: <code>pacman -Rns <code><var>PACKAGE</var></code></code>

### List packages
* List packages that are not direct dependencies (includes optional dependencies): <code>pacman -Qtt</code>

## GnuPG

### Create keys
* Create a GPG signing key: <code>gpg --full-generate-key</code>
* Add a GPG authentication key: <code>gpg --edit-key --expert <code><var>KEY_ID</var></code></code>
    * <code>addkey</code>
    * <code>ECC (set your own capabilities)</code>
    * <code>Toggle the authenticate capability</code>
    * <code>Toggle the sign capability</code>
    * <code>Finished</code>
* Use the GPG authentication key as an SSH key: <code>echo <code><var>KEY_GRIP</var></code> > "${GNUPGHOME}/sshcontrol"</code>
    > 💡 **Tip**: The key grip can be found by running: <code>gpg --list-keys --with-keygrip</code>

### Export keys
* Export a public key: <code>gpg --export --output public.key <code><var>KEY_ID</var></code></code>
* Export a secret key: <code>gpg --export-secret-key --output secret.key <code><var>KEY_ID</var></code></code>
* Export the owner trust: <code>gpg --export-ownertrust > trust.txt</code>
* Export a revocation key: <code>gpg --gen-revoke --output revoke.key <code><var>KEY_ID</var></code></code>
* Export an SSH public key: <code>gpg --export-ssh-key <code><var>KEY_ID</var></code></code>
    > 📝 **Note**: This sub-key is automatically imported when the main key is imported.

### Import keys
* Import a public key: <code>gpg --import public.key</code>
* Import a secret key: <code>gpg --import secret.key</code>
* Import the owner trust: <code>gpg --import-ownertrust trust.txt</code>

### Revoke keys
* Revoke a key: <code>gpg --import revoke.key</code>

## Storage

### Archive files
* Compress a file: <code>tar --create --file="<code><var>FILE</var></code>.tar.xz" --xattrs --xattrs-include="*" --xz <code><var>FILE</var></code></code>
* Encrypt a file: <code>gpg --cipher-algo AES256 --output <code><var>FILE</var></code>.tar.xz.gpg --symmetric <code><var>FILE</var></code>.tar.xz</code>

### Unarchive files
* Unencrypt a file: <code>gpg --decrypt --output <code><var>FILE</var></code>.tar.xz <code><var>FILE</var></code>.tar.xz.gpg</code>
* Decompress a file: <code>tar --extract --file="<code><var>FILE</var></code>.tar.xz" --xattrs --xattrs-include="*" --xz</code>

## Networking

### Get devices
* List all devices: <code>iwctl device list</code>

### Get networks
* List all networks: <code>iwctl station <code><var>DEVICE</var></code> get-networks</code>

### Connect
* Connect to a network: <code>iwctl station <code><var>DEVICE</var></code> connect <code><var>SSID</var></code></code>

### Disconnect
* Disconnect from a network: <code>iwctl station <code><var>DEVICE</var></code> disconnect</code>

### Get saved networks
* List saved networks: <code>iwctl known-networks list</code>

### Forget networks
* Forget a network: <code>iwctl known-networks <code><var>SSID</var></code> forget</code>

## Bluetooth

### Get devices
* List all devices: <code>bluetoothctl</code>
    * <code>scan on</code>
    * <code>devices</code>

### Connect
* Connect to a device: <code>bluetoothctl</code>
    * <code>pair <code><var>MAC_ADDRESS</var></code></code>
    * <code>trust <code><var>MAC_ADDRESS</var></code></code>
    * <code>connect <code><var>MAC_ADDRESS</var></code></code>
 
### Disconnect
* Disconnect from a device: <code>bluetoothctl</code>
    * <code>disconnect <code><var>MAC_ADDRESS</var></code></code>
 
### Forget devices
* Forget a device: <code>bluetoothctl</code>
    * <code>remove <code><var>MAC_ADDRESS</var></code></code>

## Graphics

### Switch GPUs
* Use the integrated GPU: <code>sudo envycontrol -s integrated</code>
* Use hybrid GPUs: <code>sudo envycontrol -s hybrid</code>
* Use the dedicated GPU: <code>sudo envycontrol -s nvidia</code>

### Using GPUs
* Run a program using the dedicated GPU in hybrid mode: <code>DRI_PRIME=1 <code><var>COMMAND</var></code></code>
    > 📝 **Note**: The system must be set to hybrid mode.
