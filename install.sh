#!/bin/bash

set -euo pipefail

#######
# Zsh #
#######

rm -rf "$XDG_CONFIG_HOME/zsh"
mkdir -p "$XDG_CONFIG_HOME/zsh"

rm -rf "$HOME/.zshenv"
ln -sf "$DOTFILES/zsh/.zshenv" "$HOME/.zshenv"

ln -sf "$DOTFILES/zsh/.zshrc" "$ZDOTDIR"
ln -sf "$DOTFILES/zsh/aliases" "$ZDOTDIR/aliases"

rm -rf "$XDG_CONFIG_HOME/zsh/external"
ln -sf "$DOTFILES/zsh/external" "$ZDOTDIR"

#######
# X11 #
#######

rm -rf "$XDG_CONFIG_HOME/X11"
ln -s "$DOTFILES/X11" "$XDG_CONFIG_HOME"

#############
# Alacritty #
#############

rm -rf "$XDG_CONFIG_HOME/alacritty.yml"
ln -s "$DOTFILES/alacritty/alacritty.yml" "$XDG_CONFIG_HOME"

#########
# tmuxp #
#########

rm -rf "$XDG_CONFIG_HOME/tmuxp"
ln -sf "$STATE/dotfiles/tmuxp/" "$XDG_CONFIG_HOME"

############
# Newsboat #
############

rm -rf $HOME/.config/newsboat
mkdir $HOME/.config/newsboat
ln -s "$STATE/dotfiles/urls" "$XDG_CONFIG_HOME/newsboat/urls"
ln -s "$DOTFILES/newsboat/config" "$XDG_CONFIG_HOME/newsboat/config"

###########
# Zathura #
###########

rm -rf "$XDG_CONFIG_HOME/zathura"
mkdir "$XDG_CONFIG_HOME/zathura"
ln -s "$DOTFILES/zathura/zathurarc" "$XDG_CONFIG_HOME/zathura/zathurarc"

#########
# Picom #
#########

rm -rf "$XDG_CONFIG_HOME/picom"
ln -s "$DOTFILES/picom" "$XDG_CONFIG_HOME"

#######
# GTK # 
#######

rm -rf "$XDG_CONFIG_HOME/gtk-3.0"
ln -s "$DOTFILES/gtk-3.0" "$XDG_CONFIG_HOME"

rm -rf $XDG_CONFIG_HOME/gtk-2.0
mkdir -p $XDG_CONFIG_HOME/gtk-2.0

ln -s "$DOTFILES/gtk-2.0/.gtkrc-2.0" $XDG_CONFIG_HOME/gtk-2.0/gtkrc

###############
# taskwarrior #
###############

rm -rf "$XDG_CONFIG_HOME/task"
mkdir -p $XDG_CONFIG_HOME/task
ln -sf "$DOTFILES/taskwarrior/.taskrc" "$XDG_CONFIG_HOME/task/taskrc"

#######
# Git #
#######

rm -rf "$XDG_CONFIG_HOME/git"
mkdir -p $XDG_CONFIG_HOME/git
ln -s "$STATE/dotfiles/gitconfig" $XDG_CONFIG_HOME/git/config

############
# redshift #
############

rm -rf "$XDG_CONFIG_HOME/redshift"
mkdir "$XDG_CONFIG_HOME/redshift"
ln -s "$DOTFILES/redshift/redshift.conf" "$XDG_CONFIG_HOME/redshift/redshift.conf"

############
# PHPStorm #
############

rm -rf $XDG_CONFIG_HOME/ideavim
mkdir -p $XDG_CONFIG_HOME/ideavim

ln -s "$DOTFILES/jetbrains/phpstorm/.ideavimrc" "$XDG_CONFIG_HOME/ideavim/ideavimrc"

########
# nvim #
########

rm -rf "$XDG_CONFIG_HOME/nvim"
ln -s "$DOTFILES/nvim" "$XDG_CONFIG_HOME"

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


#########
# dunst #
#########

rm -rf "$XDG_CONFIG_HOME/dunst"
ln -sf "$DOTFILES/dunst" "$XDG_CONFIG_HOME"

########
# tmux #
########

rm -rf "$XDG_CONFIG_HOME/tmux"
mkdir "$XDG_CONFIG_HOME/tmux"
ln -sf "$DOTFILES/tmux/tmux.conf" "$XDG_CONFIG_HOME/tmux/tmux.conf"

[ ! -d "$XDG_CONFIG_HOME/tmux/plugins" ] \
&& git clone https://github.com/tmux-plugins/tpm \
"$XDG_CONFIG_HOME/tmux/plugins/tpm"

######
# lf #
######

rm -rf $XDG_CONFIG_HOME/lf
mkdir $XDG_CONFIG_HOME/lf
ln -s $DOTFILES/lf/lfrc $XDG_CONFIG_HOME/lf/lfrc

################
# Applications #
################

mkdir -p $XDG_DATA_HOME/applications
ln -sf $DOTFILES/desktop-files/* $XDG_DATA_HOME/applications/

############
# mimeapps #
############

ln -sf $DOTFILES/mimeapps/mimeapps.list $XDG_CONFIG_HOME/mimeapps.list

#######
# vit #
#######

rm -rf $XDG_CONFIG_HOME/vit
mkdir $XDG_CONFIG_HOME/vit
ln -s $DOTFILES/vit/config.ini $XDG_CONFIG_HOME/vit/config.ini

#######
# npm #
#######

rm -rf $XDG_CONFIG_HOME/npm
mkdir $XDG_CONFIG_HOME/npm
ln -s $DOTFILES/npm/npmrc $XDG_CONFIG_HOME/npm/npmrc

##############
# fontconfig #
##############

rm -rf $XDG_CONFIG_HOME/fontconfig
mkdir $XDG_CONFIG_HOME/fontconfig/
ln -s $DOTFILES/fontconfig/fonts.conf $XDG_CONFIG_HOME/fontconfig/fonts.conf

#################
# xdg-user-dirs #
#################

rm -rf $XDG_CONFIG_HOME/user-dirs.dirs
ln -s "$DOTFILES/xdg-user-dirs/user-dirs.dirs" "$XDG_CONFIG_HOME/user-dirs.dirs"

#########
# mycli #
#########

rm -rf $XDG_CONFIG_HOME/myclirc
ln -s $DOTFILES/mycli/myclirc $XDG_CONFIG_HOME/myclirc
