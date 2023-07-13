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

############
# Newsboat #
############

rm -rf "$HOME/.newsboat/urls"
ln -s "$NOTES_HOME/urls" "$HOME/.newsboat/urls"

###########
# Zathura #
###########

rm -rf "$XDG_CONFIG_HOME/zathura/"
ln -sf "$DOTFILES/zathura/" "$XDG_CONFIG_HOME"

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

rm -rf "$HOME/.gtkrc-2.0"
ln -s "$DOTFULES/gtk-2.0/.gtkrc-2.0" $HOME

###############
# taskwarrior #
###############

rm -rf "$HOME/.taskrc"
ln -s "$DOTFILES/taskwarrior/.taskrc" "$HOME"

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

rm -rf "$XDG_CONFIG_HOME/dunst"
ln -sf "$DOTFILES/dunst" "$XDG_CONFIG_HOME"

########
# tmux #
########

rm -rf "$XDG_CONFIG_HOME/tmux"
ln -sf "$DOTFILES/tmux" "$XDG_CONFIG_HOME"

[ ! -d "$XDG_CONFIG_HOME/tmux/plugins" ] \
&& git clone https://github.com/tmux-plugins/tpm \
"$XDG_CONFIG_HOME/tmux/plugins/tpm"
