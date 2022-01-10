#!/bin/bash

name=$(cat /var_username)
installer_url=$(cat /var_installer_url)
apps_path="/apps.csv"

curl "$installer_url/apps.csv" > $apps_path

choices=$(cat /var_app_choices)

selection="^$(echo $choices | sed -e 's/ /,|^/g'),"
lines=$(grep -E "$selection" "$apps_path") count=$(echo "$lines" | wc -l)
packages=$(echo "$lines" | awk -F, {'print $2'})

echo "$selection" "$lines" "$count" >> "/packages"

echo "Change tty and check progress with tail -f /mnt/arch_install"

c=0
log_file="/tmp/log"  
install_file="/tmp/arch_install"  
aur_queue_file="/tmp/aur_queue"  
install_fail_file="/tmp/arch_install_failed"

install_package() {
    local package_name="$1"

    c=$(( c + 1 ))
    echo "Downloading and installing program $c out of $count: $package_name..."

    echo "Attempting to install $package_name" >> "$log_file"
    if pacman --noconfirm --needed -S "$package_name" > "$install_file" 2>&1; then
        return 0
    else
        echo "$package_name" >> "$aur_queue_file"
        echo "$package_name" >> "$install_fail_file"
        return 1
    fi
}

set_zsh_default() {
    local name="$1"
    echo "Trying to add zsh as default shell" >> "$log_file"
    chsh -s "$(which zsh)" "$name"
}

set_x11_keymap() {
    mkdir -p /etc/X11/xorg.conf.d
    cat <<-EOF > /etc/X11/xorg.conf.d/00-keyboard.conf
    Section "InputClass"
        Identifier "system-keyboard"
        MatchIsKeyboard "on"
        Option "XkbLayout" "se"
    EndSection
EOF
    echo "X11 keymap set to Swedish ('se')."
}

echo "$packages" | while read -r package; do
    if install_package "$package"; then
        case "$package" in
            "zsh") set_zsh_default "$name" ;;
            "xorg") set_x11_keymap ;;
        esac
    fi
done

if pacman -Qq networkmanager > /dev/null 2>&1; then
  systemctl enable NetworkManager.service
fi

if pacman -Qq bluez > /dev/null 2>&1; then
  systemctl enable bluetooth.service
fi

if pacman -Qq docker > /dev/null 2>&1; then
  groupadd docker
  usermod -aG docker $name
  systemctl enable docker.service
fi

if pacman -Qq syncthing > /dev/null 2>&1; then
  systemctl enable "syncthing@${name}.service"
fi

echo "Trying to add sudoers" >> $log_file
echo "%wheel ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

curl "$installer_url/install_user.sh"  > /install_user.sh

echo "Trying to run install_user.sh" >> $log_file
sudo -u "$name" sh /install_user.sh
