#!/bin/bash
set -euo pipefail
set -x

USERNAME=""
PASSWORD=""
PASSWORD_CONFIRM=""

INSTALLER_URL="https://raw.githubusercontent.com/cl4irv0yant/dotfiles/master/scripts/OS/arch-linux"
SUDOERS="%wheel ALL=(ALL) NOPASSWD: ALL"

USER_SCRIPT="post_install_user.sh"
APPS_CSV="apps.csv"
FP_USER_SCRIPT="/tmp/$USER_SCRIPT"
FP_APPS_CSV="/tmp/$APPS_CSV"
FP_AUR_QUEUE="/tmp/aur_queue"

user_input() {
  if [ -z "$USERNAME" ]; then
    while true; do
      read -rsp "Enter username: " USERNAME
    done
  fi

  if [ -z "$PASSWORD" ]; then
    while true; do
      read -rsp "Enter password: " PASSWORD
      echo
      read -rsp "Confirm password: " PASSWORD_CONFIRM
      echo

      if [ "$PASSWORD" = "$PASSWORD_CONFIRM" ]; then
        break
      else
        echo "Passwords do not match. Please try again."
      fi
    done
  fi
}

install_package() {
  local package=$1
  if ! pacman -S --noconfirm "$package"; then
    echo "$package" >>"$FP_AUR_QUEUE"
  fi
}

install_packages() {
  curl "$INSTALLER_URL/$APPS_CSV" >"$FP_APPS_CSV"
  while IFS=, read -r category package description; do
    install_package "$package"
  done <$FP_APPS_CSV
}

user_and_groups() {
  if ! id "$USERNAME" &>/dev/null; then
    useradd -m -g wheel -s /bin/bash "$USERNAME"
    echo "$USERNAME:$PASSWORD" | chpasswd
    echo "$SUDOERS" >/etc/sudoers.d/username_wheel
  fi
}

change_shell() {
  chsh -s /bin/zsh "$USERNAME"
}

user() {
  curl "$INSTALLER_URL/$USER_SCRIPT" >$FP_USER_SCRIPT
  sudo -u $USERNAME sh $FP_USER_SCRIPT
}

main() {
  install_packages
  user_and_groups
  change_shell
  user
  cleanup
}

cleanup() {
  rm -rf $FP_APPS_CSV
  rm -rf $FP_AUR_QUEUE
  rm -rf $FP_USER_SCRIPT
}

main


##!/bin/bash
#
#USERNAME=$(cat /var_username)
#PASSWORD=$(cat /var_password)
#
#system_administration() {
#  users_and_groups() {
#    useradd -m -g wheel -s /bin/bash "$USERNAME"
#    echo "$USERNAME:$PASSWORD" | chpasswd
#
#    pacman -S --noconfirm sudo
#    echo '%wheel ALL=(ALL) ALL' >>/etc/sudoers
#
#    mkdir -p /etc/systemd/system/getty@tty1.service.d
#    echo "[Service]
#    ExecStart=
#    ExecStart=-/usr/bin/agetty --autologin $USERNAME --noclear %I 38400 linux" >/etc/systemd/system/getty@tty1.service.d/override.conf
#
#    systemctl daemon-reload
#    systemctl restart getty@tty1.service
#  }
#
#  security() {
#    pacman -Syu
#    pacman -S --noconfirm ufw fail2ban
#    ufw enable
#    systemctl enable ufw
#  }
#
#  service_management() {
#    systemctl enable sshd.service
#    systemctl start sshd.service
#  }
#
#  system_maintenance() {
#    pacman -S --noconfirm cronie
#  }
#
#  users_and_groups
#  security
#  service_management
#  system_maintenance
#}
#
#package_management() {
#  pacman_configuration() {
#    pacman -Syu
#
#    pacman -S --noconfirm base-devel git vim
#  }
#
#  repositories() {
#    pacman -S --noconfirm reflector
#  }
#
#  mirrors() {
#    pacman -S --noconfirm reflector
#  }
#
#  arch_build_system() {
#    pacman -S --noconfirm reflector
#  }
#
#  arch_user_repository() {
#    pacman -S --noconfirm --needed base-devel git
#    sudo -u your_username bash -c 'git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si --noconfirm'
#    sudo -u your_username bash -c 'cd && rm -rf yay'
#  }
#
#  pacman_configuration
#  repositories
#  mirrors
#  arch_build_system
#  arch_user_repository
#}
#
#booting() {
#  hardware_auto_recognition() {
#    echo "udev"
#  }
#
#  microcode() {
#    pacman -S --noconfirm intel-ucode
#    grub-mkconfig -o /boot/grub/grub.cfg
#  }
#
#  retaining_boot_messages() {
#    mkdir -p /var/log/journal
#    systemd-tmpfiles --create --prefix /var/log/journal
#  }
#
#  num_lock_activation() {
#    pacman -S --noconfirm numlockx
#    echo 'if [ -x /usr/bin/numlockx ]; then /usr/bin/numlockx on; fi' >>/etc/xprofile
#  }
#
#  hardware-auto-recognition
#  microcode
#  retaining-boot-messages
#  num-lock-activation
#}
#
#graphical_user_interface() {
#  display_server() {
#    pacman -S --noconfirm xorg
#  }
#
#  display_drivers() {
#    pacman -S --noconfirm nvidia nvidia-utils
#  }
#
#  window_managers_or_compositors() {
#    pacman -S --noconfirm i3-wm polybar rofi redshift dunst picom
#  }
#
#  display_manager() {
#    pacman -S --noconfirm lightdm lightdm-gtk-greeter
#    systemctl enable lightdm
#  }
#
#  user_directories() {
#    pacman -S --noconfirm xdg-user-dirs
#    xdg-user-dirs-update
#  }
#
#  display_server
#  display_drivers
#  window_managers_or_compositors
#  display_manager
#  user_directories
#}
#
#power_management() {
#  acpi_events() {
#    pacman -S --noconfirm acpid
#    systemctl enable acpid.service
#    systemctl start acpid.service
#  }
#
#  cpu_frequency_scaling() {
#    pacman -S --noconfirm cpupower
#    systemctl enable cpupower.service
#    systemctl start cpupower.service
#  }
#
#  suspend_and_hibernate() {
#    echo "TODO: fix suspend and hibernate"
#  }
#
#  acpi-events
#  cpu-frequency-scaling
#  laptops
#  suspend-and-hibernate
#}
#
#multimedia() {
#  sound_system() {
#    pacman -S --noconfirm alsa-utils
#  }
#  sound_system
#}
#
#networking() {
#  dns_security() {
#    pacman -S --noconfirm dnscrypt-proxy
#    systemctl enable dnscrypt-proxy.service
#    systemctl start dnscrypt-proxy.service
#  }
#
#  firewall() {
#    pacman -S --noconfirm ufw
#    systemctl enable ufw.service
#    systemctl start ufw.service
#    ufw default deny incoming
#    ufw default allow outgoing
#    ufw enable
#  }
#
#  network_shares() {
#    pacman -S --noconfirm samba
#    cp /etc/samba/smb.conf.default /etc/samba/smb.conf
#    systemctl enable smb.service
#    systemctl start smb.service
#    systemctl enable nmb.service
#    systemctl start nmb.service
#  }
#
#  clock_synchronization() {
#    pacman -S --noconfirm ntp
#    systemctl enable ntpd.service
#    systemctl start ntpd.service
#  }
#  clock_synchronization
#  dns_security
#  firewall
#  network_shares
#}
#
#input_devices() {
#  keyboard_layouts() {
#    mkdir -p /etc/X11/xorg.conf.d/
#    echo -e 'Section "InputClass"\n        Identifier "system-keyboard"\n        MatchIsKeyboard "on"\n        Option "XkbLayout" "se"\n        Option "XkbVariant" "altgr-intl"\n        Option "XkbOptions" "terminate:ctrl_alt_bksp"\nEndSection' >/etc/X11/xorg.conf.d/00-keyboard.conf
#  }
#
#  mouse_buttons() {
#    pacman -S --noconfirm xbindkeys xautomation
#  }
#
#  laptop_touchpads() {
#    pacman -S --noconfirm xf86-input-synaptics
#
#    DEVICE_ID=$(xinput list --id-only 'VEN_04F3:00 04F3:311C Touchpad')
#
#    xinput set-prop "$DEVICE_ID" 'libinput Tapping Enabled' 1
#
#    echo 'Section "InputClass"
#          Identifier "tap"
#          MatchIsTouchpad "on"
#          Option "Tapping" "on"
#          Driver "libinput"
#      EndSection' | sudo tee /etc/X11/xorg.conf.d/40-libinput.conf >/dev/null
#  }
#
#  keyboard_layouts
#  mouse_buttons
#  laptop_touchpads
#}
#
##optimization()
##{
##  benchmarking
##  improving-performance
##  solid-state-drives
##}
##
##system-services()
##{
##  file-index-and-search
##  local-mail-delivery
##  printing
##}
##
##appearance()
##{
##  fonts
##  gtk-and-qt-themes
##}
##
##console-improvements()
##{
##  tab-completion
##  aliases
##  alternative-shells
##  bash-additions
##  colored-output
##  compressed-files
##  console-prompt
##  emacs-shell
##  mouse-support
##  session-management
##}
#
##if ! command -v gh &> /dev/null
##then
##    echo "gh (GitHub CLI) could not be found, please install it first."
##    exit
##fi
##
##if ! command -v ssh-keygen &> /dev/null
##then
##    echo "ssh-keygen could not be found, please install it first."
##    exit
##fi
##
##ssh-keygen -t ed25519 -C "gustaf.silver@sweetspot.io"
##
##eval "$(ssh-agent -s)"
##ssh-add $HOME/.ssh/id_ed25519
##
##gh ssh-key add $HOME/.ssh/id_ed25519.pub --title "Generated key on $(date)"
##
##chmod 400 $HOME/.ssh/id_ed25519
#
#main() {
#  system_administration
#  package_management
#  booting
#  graphical_user_interface
#  power_management
#  multimedia
#  networking
#  input_devices
#  optimization
#  system_services
#  appearance
#  console_improvements
#}
#
#main "$@"
