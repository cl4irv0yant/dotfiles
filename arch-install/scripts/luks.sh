dd bs=512 count=4 if=/dev/random of=/root/cryptlvm.keyfile iflag=fullblock
chmod 600 /root/cryptlvm.keyfile
cryptsetup -v luksAddKey /dev/nvme0n1p2 /root/cryptlvm.keyfile


MKINITCPIO_CONF="/etc/mkinitcpio.conf"
NEW_FILES="FILES=(/root/cryptlvm.keyfile)"

sed -i "s/FILES=(\)/${NEW_FILES}/" ${MKINITCPIO_CONF}
chmod 600 /boot/initramfs-linux*


GRUB_CFG="/etc/default/grub"

CRYPT_UUID=$(grep -oP 'cryptdevice=UUID=\K[^:]*' $GRUB_CFG)
ROOT_UUID=$(grep -oP 'root=UUID=\K[^ ]*' $GRUB_CFG)

NEW_CMDLINE_LINUX="GRUB_CMDLINE_LINUX=\"cryptdevice=UUID=${CRYPT_UUID}:root root=UUID=${ROOT_UUID} cryptkey=rootfs:/root/cryptlvm.keyfile\""

sed -i "s/^GRUB_CMDLINE_LINUX=.*/${NEW_CMDLINE_LINUX}/" ${GRUB_CFG}

echo "GRUB configuration file updated successfully!"

