# Cheat sheet

## Portage

### Upgrade all packages
* `emaint --auto sync`
* `eselect news read`
* `eselect news purge`
* `emerge --ask --deep --newuse --update --verbose --with-bdeps=y @world`
* `dispatch-conf`
* `emerge --ask --depclean`

### Remove a package
* `emerge --deselect ${package}`
* `emerge --ask --depclean`

## GPG

### Export keys
* `gpg --export --output public.key ${keyId}`
* `gpg --export-secret-key --output secret.key ${keyId}`
* `gpg --export-ownertrust > trust.txt`
* `gpg --gen-revoke --output revoke.key ${keyId}`

### Import keys
* `gpg --import public.key`
* `gpg --import secret.key`
* `gpg --import revoke.key`
* `gpg --import-ownertrust trust.txt`

## Storage

### Archive a file
* `tar --create --file="${file}.tar.xz" --xattrs --xattrs-include="*" --xz ${file}`
* `gpg --cipher-algo AES256 --output ${file}.tar.xz.gpg --symmetric ${file}.tar.xz`

### Unarchive a file
* `gpg --decrypt --output ${file}.tar.xz ${file}.tar.xz.gpg`
* `tar --extract --file="${file}.tar.xz" --xattrs --xattrs-include="*" --xz`

## Networking

### List all networks
* `iwctl device list`
* `iwctl station ${wlan} get-networks`

### Connect to a network
* `iwctl station ${wlan} connect ${name}`

### Disconnect from a network
* `iwctl station ${wlan} disconnect`

### List known networks
* `iwctl known-networks list`

### Forget a network
* `iwctl known-netowkrs ${name} forget`

## Bluetooth

### List all devices
* `bluetoothctl`
    * `scan on`
    * `devices`

### Connect to a device
* `bluetoothctl`
    * `pair device_mac_address`
    * `trust device_mac_address`
    * `connect device_mac_address`
 
### Disconnect from a device
* `bluetoothctl`
    * `disconnect device_mac_address`
 
### Forget a device
* `bluetoothctl`
    * `remove device_mac_address`
