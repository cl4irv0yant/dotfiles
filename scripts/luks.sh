dd bs=512 count=4 if=/dev/random of=/root/cryptlvm.keyfile iflag=fullblock
chmod 600 /root/cryptlvm.keyfile
cryptsetup -v luksAddKey /dev/nvme0n1p2 /root/cryptlvm.keyfile


MKINITCPIO_CONF="/etc/mkinitcpio.conf"
NEW_FILES="FILES=(/root/cryptlvm.keyfile)"

sed -i "s/FILES=(\)/${NEW_FILES}/" ${MKINITCPIO_CONF}
chmod 600 /boot/initramfs-linux*


# Define the path to grub configuration file
GRUB_CFG="/etc/default/grub"

# Fetch the UUID values from the GRUB_CMDLINE_LINUX variable
CRYPT_UUID=$(grep -oP 'cryptdevice=UUID=\K[^:]*' $GRUB_CFG)
ROOT_UUID=$(grep -oP 'root=UUID=\K[^ ]*' $GRUB_CFG)

# Define the new GRUB_CMDLINE_LINUX value with the UUID variables
NEW_CMDLINE_LINUX="GRUB_CMDLINE_LINUX=\"cryptdevice=UUID=${CRYPT_UUID}:root root=UUID=${ROOT_UUID} cryptkey=rootfs:/root/cryptlvm.keyfile\""

# Use sed to find and replace the old GRUB_CMDLINE_LINUX value with the new one
sed -i "s/^GRUB_CMDLINE_LINUX=.*/${NEW_CMDLINE_LINUX}/" ${GRUB_CFG}

echo "GRUB configuration file updated successfully!"

