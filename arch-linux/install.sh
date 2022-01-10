#!/bin/bash
set -euo pipefail
set -x

INSTALLER_URL="https://raw.githubusercontent.com/cl4irv0yant/dotfiles/master/arch-linux"

HOSTNAME=""
ROOT_PASSWORD=""
ENCRYPTION_PASSWORD=""
SWAP_SIZE=""
HARD_DRIVE=""

ENCRYPTION_PASSWORD_CONFIRM=""
ROOT_PASSWORD_CONFIRM=""
BOOT_PARTITION=1
SWAP_PARTITION=2
ROOT_PARTITION=3

user_input() {
  if [ -z "$ROOT_PASSWORD" ]; then
    while true; do
      read -rsp "Enter root password: " ROOT_PASSWORD
      echo
      read -rsp "Confirm root password: " ROOT_PASSWORD_CONFIRM
      echo

      if [ "$ROOT_PASSWORD" = "$ROOT_PASSWORD_CONFIRM" ]; then
        break
      else
        echo "Root passwords do not match. Please try again."
      fi
    done
  fi

  if [ -z "$HOSTNAME" ]; then
    read -rp "Enter hostname: " HOSTNAME
  fi

  if [ -z "$ENCRYPTION_PASSWORD" ]; then
    while true; do
      read -rsp "Enter encryption password: " ENCRYPTION_PASSWORD
      echo
      read -rsp "Confirm encryption password: " ENCRYPTION_PASSWORD_CONFIRM
      echo

      if [ "$ENCRYPTION_PASSWORD" = "$ENCRYPTION_PASSWORD_CONFIRM" ]; then
        break
      else
        echo "Encryption passwords do not match. Please try again."
      fi
    done
  fi

  if [ -z "$HARD_DRIVE" ]; then
    mapfile -t devices_list < <(lsblk -d -n -o NAME,SIZE | awk '{print "/dev/" $1 " " $2 " on"}' | grep -E 'sd|hd|vd|nvme|mmcblk')
    dialog --title "Choose hard drive" --no-cancel --radiolist "Select with SPACE, continue with ENTER" 15 60 4 "${devices_list[@]}" 2>hd_temp
    HARD_DRIVE=$(<hd_temp)
    rm -f hd_temp
  fi

  if [ -z "$SWAP_SIZE" ]; then
    dialog --no-cancel --inputbox "Enter the partition size (in GB) for Swap or leave it empty." 20 60 2>swap_size
    SWAP_SIZE=$(cat swap_size)
  fi
}

verify_boot_mode() {
  UEFI=0
  
  if [[ -d /sys/firmware/efi ]]; then
    UEFI=1
    echo "System is in UEFI mode."
  else
    echo "System is in Legacy/BIOS mode."
  fi
}

update_system_clock() {
  timedatectl set-ntp true
}

partition_disks() {
  if [ -z "$SWAP_SIZE" ]; then
    ROOT_PARTITION=$((ROOT_PARTITION - 1))
  fi

  partprobe "$HARD_DRIVE"

  if [ "$UEFI" -eq 1 ]; then
    parted --script "$HARD_DRIVE" mklabel gpt
    parted --script "$HARD_DRIVE" mkpart ESP fat32 1MiB 512MiB
    parted --script "$HARD_DRIVE" set 1 esp on
  else
    parted --script "$HARD_DRIVE" mklabel msdos
    parted --script "$HARD_DRIVE" mkpart primary ext4 1MiB 512MiB
    parted --script "$HARD_DRIVE" set 1 boot on
  fi

  if [ -n "$SWAP_SIZE" ]; then
    parted --script "$HARD_DRIVE" mkpart primary linux-swap 513MiB $((SWAP_SIZE + 513))MiB
    parted --script "$HARD_DRIVE" mkpart primary ext4 $((SWAP_SIZE + 514))MiB 100%
  else
    parted --script "$HARD_DRIVE" mkpart primary ext4 513MiB 100%
  fi

  partprobe "$HARD_DRIVE"
}

format_partition() {
  echo "$HARD_DRIVE" | grep -E 'nvme' &>/dev/null && HARD_DRIVE="${HARD_DRIVE}p"

  cryptsetup luksFormat "${HARD_DRIVE}${ROOT_PARTITION}" <<<"$ENCRYPTION_PASSWORD"
  cryptsetup open "${HARD_DRIVE}${ROOT_PARTITION}" root <<<"$ENCRYPTION_PASSWORD"

  mkfs.ext4 /dev/mapper/root

  [ -n "$SWAP_SIZE" ] && mkswap "${HARD_DRIVE}${SWAP_PARTITION}"

  if [ "$UEFI" -eq 1 ]; then
    mkfs.fat -F32 "${HARD_DRIVE}${BOOT_PARTITION}"
  else
    mkfs.ext4 "${HARD_DRIVE}${BOOT_PARTITION}"
  fi
}

mount_file_system() {
  mount /dev/mapper/root /mnt
  mount --mkdir "${HARD_DRIVE}${BOOT_PARTITION}" /mnt/boot
  [ -n "$SWAP_SIZE" ] && swapon "${HARD_DRIVE}${SWAP_PARTITION}"
}

select_mirrors() {
  reflector --verbose --latest 20 --sort rate --save /etc/pacman.d/mirrorlist
  pacman -Syy
}

install_essential_packages() {
  pacstrap -K /mnt base base-devel linux linux-firmware networkmanager iwd
}

fstab() {
  genfstab -U /mnt >>/mnt/etc/fstab
}

chroot() {
  echo "$HARD_DRIVE" >/mnt/var_hard_drive
  echo "$HOSTNAME" >/mnt/var_hostname
  echo "$ROOT_PARTITION" >/mnt/var_root_partition
  echo "$ROOT_PASSWORD" >/mnt/var_root_password
  echo "$UEFI" >/mnt/var_uefi

  curl "$INSTALLER_URL/chroot.sh" >/mnt/chroot.sh
  arch-chroot /mnt bash chroot.sh
}

pre_installation() {
  verify_boot_mode
  update_system_clock
  partition_disks
  format_partition
  mount_file_system
}

installation() {
  select_mirrors
  install_essential_packages
}

configure_system() {
  fstab
  chroot
}

prepare_post_install() {
  curl "$INSTALLER_URL/post_install_root.sh" >/mnt/root/post_install_root.sh
}

cleanup_and_reboot() {
  rm -rf /mnt/var_hard_drive
  rm -rf /mnt/var_hostname
  rm -rf /mnt/var_root_partition
  rm -rf /mnt/var_root_password
  rm -rf /mnt/var_uefi
  rm -rf /mnt/chroot.sh
  reboot
}

main() {
  user_input
  pre_installation
  installation
  configure_system
  prepare_post_install
  cleanup_and_reboot
}

for arg in "$@"; do
  case $arg in
    --test)
      HOSTNAME="arch"
      ROOT_PASSWORD="pass"
      ENCRYPTION_PASSWORD="pass"
      SWAP_SIZE=8
      HARD_DRIVE="/dev/sda"
      ;;
    *) ;;
  esac
done

main
