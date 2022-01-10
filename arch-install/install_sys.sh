#!/bin/bash
set -euo pipefail

url_installer() {
    echo "https://raw.githubusercontent.com/cl4irv0yant/dotfiles/cleanup/arch-install"
}
INSTALLER_URL=$(url_installer)

curl "$INSTALLER_URL/apps.csv" > apps.csv

USERNAME=""
PASSWORD=""
ROOT_PASSWORD=""
PASSWORD_CONFIRM=""
ROOT_PASSWORD_CONFIRM=""
HOSTNAME=""
ENCRYPTION_PASSWORD=""
ENCRYPTION_PASSWORD_CONFIRM=""
SWAP_SIZE=""
AUTOMATE_TESTS="false"

for arg in "$@"; do
  case $arg in
    --test)
      echo "Running in test mode."
      USERNAME="test_user"
      PASSWORD="test_pass"
      ROOT_PASSWORD="test_root_pass"
      HOSTNAME="test_host"
      ENCRYPTION_PASSWORD="test_encrypt_pass"
      SWAP_SIZE=8
      HARD_DRIVE="/dev/sda"
      AUTOMATE_TESTS="true"
      ;;
    *)
      ;;
  esac
done

if [ -z "$USERNAME" ]; then
  read -p "Enter username: " USERNAME
  
  while true; do
    read -sp "Enter password: " PASSWORD
    echo
    read -sp "Confirm password: " PASSWORD_CONFIRM
    echo

    if [ "$PASSWORD" = "$PASSWORD_CONFIRM" ]; then
      break
    else
      echo "Passwords do not match. Please try again."
    fi 
  done

  while true; do
    read -sp "Enter root password: " ROOT_PASSWORD
    echo
    read -sp "Confirm root password: " ROOT_PASSWORD_CONFIRM
    echo

    if [ "$ROOT_PASSWORD" = "$ROOT_PASSWORD_CONFIRM" ]; then
      break
    else
      echo "Root passwords do not match. Please try again."
    fi
  done

  read -p "Enter hostname: " HOSTNAME

  while true; do
    read -sp "Enter encryption password: " ENCRYPTION_PASSWORD
    echo
    read -sp "Confirm encryption password: " ENCRYPTION_PASSWORD_CONFIRM
    echo

    if [ "$ENCRYPTION_PASSWORD" = "$ENCRYPTION_PASSWORD_CONFIRM" ]; then
      break
    else
      echo "Encryption passwords do not match. Please try again."
    fi
  done

  echo
fi

if [[ ! -r "apps.csv" ]]; then
  echo "Error: 'apps.csv' does not exist or is not readable."
  exit 1
fi

declare -A unique_categories
declare -a apps
declare -a dialog_options

while IFS=, read -r category app description; do
  apps+=("$category-$app" "$description" "on")
  unique_categories["$category"]=1
done < apps.csv

if [ "${AUTOMATE_TESTS:-}" == "true" ]; then
  APP_CHOICES=$(echo "${!unique_categories[@]}" | tr ' ' ' ')
else
    for category in "${!unique_categories[@]}"; do
      dialog_options+=("$category" " " "on")
    done

    user_choices=$(dialog --clear \
                    --backtitle "App Installer" \
                    --no-cancel \
                    --checklist "Select application categories to install:" \
                    20 50 15 \
                    "${dialog_options[@]}" \
                    2>&1 >/dev/tty)
    clear
    APP_CHOICES=$(echo "$user_choices" | sed "s/\"//g" | sed "s/ / /g")
fi

timedatectl set-ntp true

uefi=0
ls /sys/firmware/efi/efivars &>/dev/null && uefi=1

if [ -z "$HARD_DRIVE" ]; then
    devices_list=($(lsblk -d | awk '{print "/dev/" $1 " " $4 " on"}' | grep -E 'sd|hd|vd|nvme|mmcblk'))
    dialog --title "Choose hard drive" --no-cancel --radiolist "Select with SPACE, continue with ENTER" 15 60 4 "${devices_list[@]}" 2> hd_temp
    HARD_DRIVE=$(cat hd_temp)
    rm -f hd_temp
fi

if [ -z "$SWAP_SIZE" ]; then 
    dialog --no-cancel --inputbox "Enter the partition size (in GB) for Swap or leave it empty." 20 60 2> swap_size
    size=$(cat swap_size)
fi

boot_partition=1
swap_partition=2
root_partition=3

if [ -z "$SWAP_SIZE" ]; then
    root_partition=$((root_partition - 1))
fi

partprobe "$HARD_DRIVE"

if [ "$uefi" -eq 1 ]; then
    parted --script "$HARD_DRIVE" mklabel gpt
    parted --script "$HARD_DRIVE" mkpart ESP fat32 1MiB 512MiB
    parted --script "$HARD_DRIVE" set 1 esp on
else
    parted --script "$HARD_DRIVE" mklabel msdos
    parted --script "$HARD_DRIVE" mkpart primary ext4 1MiB 512MiB
    parted --script "$HARD_DRIVE" set 1 boot on
fi

if [ -n "$SWAP_SIZE" ]; then
    parted --script "$HARD_DRIVE" mkpart primary linux-swap 513MiB $((${SWAP_SIZE} + 513))MiB
    parted --script "$HARD_DRIVE" mkpart primary ext4 $((${SWAP_SIZE} + 514))MiB 100%
else
    parted --script "$HARD_DRIVE" mkpart primary ext4 513MiB 100%
fi
partprobe "$HARD_DRIVE"

echo "$HARD_DRIVE" | grep -E 'nvme' &> /dev/null && HARD_DRIVE="${HARD_DRIVE}p"

cryptsetup luksFormat --type=luks1 "${HARD_DRIVE}${root_partition}" <<< "$ENCRYPTION_PASSWORD"
cryptsetup open "${HARD_DRIVE}${root_partition}" root <<< "$ENCRYPTION_PASSWORD"

mkfs.ext4 /dev/mapper/root
mount /dev/mapper/root /mnt

if [ "$uefi" -eq 1 ]; then
    mkfs.fat -F32 "${HARD_DRIVE}${boot_partition}"
else
    mkfs.ext4 "${HARD_DRIVE}${boot_partition}"
fi

mkdir -p /mnt/boot
mount "${HARD_DRIVE}${boot_partition}" /mnt/boot

[ ! -z "$SWAP_SIZE" ] && mkswap "${HARD_DRIVE}${swap_partition}" && swapon "${HARD_DRIVE}${swap_partition}"

pacstrap -K /mnt base base-devel linux linux-firmware
genfstab -U /mnt >> /mnt/etc/fstab

echo "$HARD_DRIVE" > /mnt/var_hd
echo "$HOSTNAME" > /mnt/var_hostname
echo "$USERNAME" > /mnt/var_username
echo "$PASSWORD" > /mnt/var_password
echo "$ROOT_PASSWORD" > /mnt/var_root_password
echo "$APP_CHOICES" > /mnt/var_app_choices
echo "$INSTALLER_URL" > /mnt/var_installer_url
echo "$uefi" > /mnt/var_uefi
echo "$root_partition" > /mnt/var_root_partition

curl "$INSTALLER_URL/install_chroot.sh" > /mnt/install_chroot.sh
arch-chroot /mnt bash install_chroot.sh

#rm -rf /mnt/var_uefi
#rm -rf /mnt/var_hd
#rm -rf /mnt/var_hostname
#rm -rf /mnt/var_root_partition
#rm -rf /mnt/var_username
#rm -rf /mnt/var_password
#rm -rf /mnt/var_root_password
#rm -rf /mnt/var_app_choices
#rm -rf /mnt/var_installer_url
#rm -rf /mnt/install_chroot

umount -R /mnt
#reboot
