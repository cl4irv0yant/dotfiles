#!/bin/bash

set -euo pipefail

mkdir -p "$XDG_CONFIG_HOME"

# zsh
mkdir -p "$ZDOTDIR"
ln -sf "$DOTFILES"/zsh/zshenv "$HOME"/.zshenv
ln -sf "$DOTFILES"/zsh/zshrc "$ZDOTDIR"/.zshrc
ln -sf "$DOTFILES"/zsh/aliases "$ZDOTDIR"/aliases
ln -sf "$DOTFILES"/zsh/external "$ZDOTDIR"
ln -sf "$DOTFILES"/zsh/scripts "$ZDOTDIR"

# alacritty

rm -rf "$XDG_CONFIG_HOME"/alacritty
ln -sf "$DOTFILES"/alacritty "$XDG_CONFIG_HOME"

# tmuxp

rm -rf "$XDG_CONFIG_HOME"/tmuxp
ln -sf "$SYNC"/dotfiles/tmuxp "$XDG_CONFIG_HOME"

# zathura

rm -rf "$XDG_CONFIG_HOME"/zathura
ln -s "$DOTFILES"/zathura "$XDG_CONFIG_HOME"

# gtk

rm -rf "$XDG_CONFIG_HOME"/gtk-3.0
ln -s "$DOTFILES"/gtk-3.0 "$XDG_CONFIG_HOME"

rm -rf "$XDG_CONFIG_HOME"/gtk-2.0
ln -s "$DOTFILES"/gtk-2.0 "$XDG_CONFIG_HOME"

# git

rm -rf "$XDG_CONFIG_HOME"/git
ln -s "$DOTFILES"/git "$XDG_CONFIG_HOME"

# phpstorm

rm -rf "$XDG_CONFIG_HOME"/ideavim
ln -s "$DOTFILES"/jetbrains/ideavim "$XDG_CONFIG_HOME"

# nvim

rm -rf "$XDG_CONFIG_HOME"/nvim
ln -s "$DOTFILES"/nvim "$XDG_CONFIG_HOME"

# hypr

rm -rf "$XDG_CONFIG_HOME"/hypr
ln -s "$DOTFILES"/hypr "$XDG_CONFIG_HOME"

# waybar

rm -rf "$XDG_CONFIG_HOME"/waybar
ln -sf "$DOTFILES"/waybar "$XDG_CONFIG_HOME"

# wofi

rm -rf "$XDG_CONFIG_HOME"/wofi
ln -sf "$DOTFILES"/wofi "$XDG_CONFIG_HOME"

# dunst

rm -rf "$XDG_CONFIG_HOME"/dunst
ln -sf "$DOTFILES"/dunst "$XDG_CONFIG_HOME"

# lf

rm -rf "$XDG_CONFIG_HOME"/lf
ln -s "$DOTFILES"/lf "$XDG_CONFIG_HOME"

# applications


rm -rf "$XDG_DATA_HOME"/applications
mkdir -p "$XDG_DATA_HOME"/applications
mkdir -p "$XDG_DATA_HOME"/applications
cp -r "$DOTFILES/applications/"* "$XDG_DATA_HOME/applications/"

# mimeapps

ln -sf "$DOTFILES"/mimeapps/mimeapps.list "$XDG_CONFIG_HOME"/mimeapps.list

# mycli

ln -sf "$DOTFILES"/mycli/myclirc "$XDG_CONFIG_HOME"/myclirc

# transmission

mkdir -p "$XDG_CONFIG_HOME"/transmission-daemon
rm -rf "$XDG_CONFIG_HOME"/transmission-daemon/settings.json
ln -sf "$DOTFILES"/transmission/settings.json "$XDG_CONFIG_HOME"/transmission-daemon/settings.json

# newsboat

rm -rf "$XDG_CONFIG_HOME"/newsboat
ln -sf "$DOTFILES"/newsboat "$XDG_CONFIG_HOME"

# tmux

rm -rf "$XDG_CONFIG_HOME"/tmux && mkdir "$XDG_CONFIG_HOME"/tmux
ln -sf "$DOTFILES"/tmux/tmux.conf "$XDG_CONFIG_HOME"/tmux/tmux.conf

[ ! -d "$XDG_CONFIG_HOME"/tmux/plugins ] &&
  git clone https://github.com/tmux-plugins/tpm \
    "$XDG_CONFIG_HOME"/tmux/plugins/tpm
