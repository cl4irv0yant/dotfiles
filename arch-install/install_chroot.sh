set -euo pipefail

installer_url=$(cat /var_installer_url)
PASSWORD=$(cat /var_password)
ROOT_PASSWORD=$(cat /var_root_password)
username=$(cat /var_username)
hostname=$(cat /var_hostname)
uefi=$(cat /var_uefi)
hd=$(cat /var_hd)
root_partition=$(cat /var_root_partition)

ln -sf /usr/share/zoneinfo/Europe/Stockholm /etc/localtime
hwclock --systohc

echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf
echo "KEYMAP=sv-latin1" >> /etc/vconsole.conf

echo $hostname > /etc/hostname
{
  echo "127.0.0.1       localhost"
  echo "::1             localhost"
  echo "127.0.1.1       $hostname"
} >> /etc/hosts

sed -i "s/^HOOKS=.*/HOOKS=(base udev keyboard autodetect modconf kms keymap consolefont block encrypt filesystems fsck)/g" /etc/mkinitcpio.conf
mkinitcpio -P

groupadd wheel
groupadd users

echo "root:$ROOT_PASSWORD" | chpasswd
echo "Trying to create user: $username"
useradd -m -g wheel -s /bin/bash "$username"
echo "Added user: $username"
echo "$username:$PASSWORD" | chpasswd


pacman -S --noconfirm grub

cryptuuid=$(blkid -o value -s UUID "${hd}${root_partition}")
decryptuuid=$(blkid -o value -s UUID /dev/mapper/root)

sed -i "s/^GRUB_CMDLINE_LINUX=.*/GRUB_CMDLINE_LINUX=\"cryptdevice=UUID=$cryptuuid:root root=UUID=$decryptuuid\"/" /etc/default/grub

pacman -S --noconfirm intel-ucode

if [ "$uefi" = 1 ]; then
    pacman -S --noconfirm efibootmgr
    grub-install --target=x86_64-efi \
        --bootloader-id=GRUB \
        --efi-directory=/boot
else
    grub-install "$hd"
fi
grub-mkconfig -o /boot/grub/grub.cfg

curl "$installer_url/install_apps.sh" > /install_apps.sh
bash install_apps.sh
