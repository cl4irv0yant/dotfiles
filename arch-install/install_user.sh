#!/bin/bash

url_installer=$(cat /var_installer_url)

aur_install() {
    curl -O "https://aur.archlinux.org/cgit/aur.git/snapshot/$1.tar.gz" \
    && tar -xvf "$1.tar.gz" \
    && cd "$1" \
    && makepkg --noconfirm -si \
    && cd - \
    && rm -rf "$1" "$1.tar.gz"
}

aur_check() {
    qm=$(pacman -Qm | awk '{print $1}')
    for arg in "$@"
    do
        if [[ "$qm" != *"$arg"* ]]; then
            yay --noconfirm -S "$arg" &>> /tmp/aur_install \
                || aur_install "$arg" &>> /tmp/aur_install
        fi
    done
}

cd /tmp
echo "Installing \"Yay\", an AUR helper..."
aur_check yay

count=$(wc -l < /tmp/aur_queue)
c=0

cat /tmp/aur_queue | while read -r line
do
    c=$(( "$c" + 1 ))
    echo "AUR install - Downloading and installing program $c out of $count: $line..."
    aur_check "$line"
done

SRC_DIR="/home/$(whoami)/State/src"
DOTFILES="${SRC_DIR}/dotfiles"

mkdir -p DOTFILES
if [ ! -d "$DOTFILES" ]; then
    git clone https://github.com/cl4irv0yant/dotfiles.git \
        "$DOTFILES" >/dev/null
    cd "$DOTFILES"
    git remote set-url origin git@github.com:cl4irv0yant/dotfiles.git
    git checkout cleanup
fi

source "$DOTFILES/zsh/.zshenv"
cd "$DOTFILES" && bash install.sh

