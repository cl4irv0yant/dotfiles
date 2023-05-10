#!/bin/bash

#######
# X11 #
#######

rm -rf "$XDG_CONFIG_HOME/X11"
ln -sf "$DOTFILES/X11" "$XDG_CONFIG_HOME"

#############
# Alacritty #
#############

rm -rf "$XDG_CONFIG_HOME/alacritty/"
ln -sf "$DOTFILES/alacritty" "$XDG_CONFIG_HOME"

#########
# Picom #
#########

rm -rf "$XDG_CONFIG_HOME/picom"
ln -s "$DOTFILES/picom/" "$XDG_CONFIG_HOME"

#######
# GTK #
#######

rm -rf "$XDG_CONFIG_HOME/gtk-3.0"
ln -s "$DOTFILES/gtk-3.0" "$XDG_CONFIG_HOME"

#######
# Git #
#######

rm -rf "$HOME/.gitconfig"
ln -s "$DOTFILES/git/.gitconfig" "$HOME"

############
# redshift #
############

rm -rf "$XDG_CONFIG_HOME/redshift"
ln -sf "$DOTFILES/redshift" "$XDG_CONFIG_HOME"

############
# PHPStorm #
############

rm -rf "$HOME/.ideavimrc"
ln -s "$DOTFILES/phpstorm/.ideavimrc" "$HOME"

########
# nvim #
########

rm -rf $XDG_CONFIG_HOME/nvim
ln -s "$DOTFILES/nvim" "$XDG_CONFIG_HOME/nvim"

######
# i3 #
######

rm -rf "$XDG_CONFIG_HOME/i3"
ln -s "$DOTFILES/i3" "$XDG_CONFIG_HOME"

##########
# Polybar #
###########

rm -rf "$XDG_CONFIG_HOME/polybar"
ln -sf "$DOTFILES/polybar" "$XDG_CONFIG_HOME"

########
# ROFI #
########

rm -rf "$XDG_CONFIG_HOME/rofi"
ln -sf "$DOTFILES/rofi" "$XDG_CONFIG_HOME"

#######
# Zsh #
#######

mkdir -p "$XDG_CONFIG_HOME/zsh"
ln -sf "$DOTFILES/zsh/.zshenv" "$HOME"
ln -sf "$DOTFILES/zsh/.zshrc" "$XDG_CONFIG_HOME/zsh"
ln -sf "$DOTFILES/zsh/aliases" "$XDG_CONFIG_HOME/zsh/aliases"
rm -rf "$XDG_CONFIG_HOME/zsh/external"
ln -sf "$DOTFILES/zsh/external" "$XDG_CONFIG_HOME/zsh"

#########
# dunst #
#########

mkdir -p "$XDG_CONFIG_HOME/dunst"
ln -sf "$DOTFILES/dunst/dunstrc" "$XDG_CONFIG_HOME/dunst/dunstrc"

########
# tmux #
########

mkdir -p "$XDG_CONFIG_HOME/tmux"
ln -sf "$DOTFILES/tmux/tmux.conf" "$XDG_CONFIG_HOME/tmux/tmux.conf"

[ ! -d "$XDG_CONFIG_HOME/tmux/plugins" ] \
&& git clone https://github.com/tmux-plugins/tpm \
"$XDG_CONFIG_HOME/tmux/plugins/tpm"
