# Arch Linux System Configuration
#### Preventing Specific Kernel Modules from Loading

To prevent specific kernel modules, such as `bluetooth` and `btusb`, from loading:

1. **Create or Edit the Blacklist Configuration File**:

    ```bash
    sudo nvim /etc/modprobe.d/bluetooth-blacklist.conf
    ```

2. **Add the Modules to be Blacklisted**:

    ```bash
    blacklist bluetooth
    blacklist btusb
    blacklist iTCO_wdt
    ```

3. **Update the Initial Ramdisk**:

    ```bash
    sudo mkinitcpio -P
    ```

## Updating `/etc/fstab` for Filesystem Mounting

To optimize filesystem mounts in `/etc/fstab`:

1. **Backup the Current `fstab`**:

    ```bash
    sudo cp /etc/fstab /etc/fstab.backup
    ```

2. **Edit `/etc/fstab`**:

    ```bash
    sudo nvim /etc/fstab
    ```

3. **Test and Apply Changes**:

    ```bash
    sudo mount -a
    ```

## Enabling Automatic TTY Login

To set up automatic login for the user `wasd` on `tty1`:

1. **Create an Override for the `getty@tty1.service`**:

    ```bash
    sudo systemctl edit getty@tty1.service
    ```

2. **Add the Following Configuration**:

    ```bash
    [Service]
    ExecStart=
    ExecStart=-/usr/bin/agetty --autologin wasd --noclear %I $TERM
    ```

3. **Reload and Restart the Service**:

    ```bash
    sudo systemctl daemon-reload
    sudo systemctl restart getty@tty1.service
    ```
