#!/bin/bash

set -euo pipefail
set -x

process_aur_queue() {
  aur_install() {
    echo "Installing $1 from AUR"
    curl -O "https://aur.archlinux.org/cgit/aur.git/snapshot/$1.tar.gz" &&
      tar -xvf "$1.tar.gz" &&
      cd "$1" &&
      makepkg --noconfirm -si &&
      cd - &&
      rm -rf "$1" "$1.tar.gz"
  }

  aur_check() {
    qm=$(pacman -Qm | awk '{print $1}')
    for arg in "$@"; do
      if [[ $qm != *"$arg"* ]]; then
        paru --noconfirm -S "$arg" &>>/tmp/aur_install ||
          aur_install "$arg" &>>/tmp/aur_install
      fi
    done
  }

  install_paru() {
    if ! pacman -Qs paru >/dev/null; then
      cd /tmp && aur_install paru-bin
    fi
  }

  install_aur_queue() {
    cat /tmp/aur_queue | while read -r line; do
      aur_check "$line"
    done
  }

  install_paru
  install_aur_queue
}

install_dotfiles() {
  $DOTFILES="/home/$(whoami)/dotfiles"
  mkdir -p $DOTFILES

  if [ ! -d "$DOTFILES" ]; then
    git clone https://github.com/cl4irv0yant/dotfiles.git "$DOTFILES" 
    cd $DOTFILES && git remote set-url origin git@github.com:cl4irv0yant/dotfiles.git
  fi

  source "$DOTFILES/zsh/.zshenv"
  cd "$DOTFILES" && bash bootstrap.sh
}

main() {
  process_aur_queue
  install_dotfiles
}

main
