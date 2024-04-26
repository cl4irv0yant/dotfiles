#!/bin/bash

set -euo pipefail

# Base directories
mkdir -p "$XDG_CONFIG_HOME"
mkdir -p "$XDG_DATA_HOME"

link_config() {
	local src=$1 dst=$2
	rm -rf "$dst"
	ln -sf "$src" "$dst"
}

# Terminal configurations
rm -rf "$ZDOTDIR"
mkdir -p "$ZDOTDIR"
link_config "$DOTFILES/config/zsh/.zshenv" "$HOME/.zshenv"
link_config "$DOTFILES/config/zsh/.zshrc" "$ZDOTDIR/.zshrc"
link_config "$DOTFILES/config/zsh/aliases" "$ZDOTDIR/aliases"
link_config "$DOTFILES/config/zsh/external" "$ZDOTDIR/external"
link_config "$DOTFILES/config/zsh/scripts" "$ZDOTDIR/scripts"

link_config "$SYNC/dotfiles/tmuxp" "$XDG_CONFIG_HOME/tmuxp"
link_config "$DOTFILES/config/nvim" "$XDG_CONFIG_HOME/nvim"
link_config "$DOTFILES/config/git" "$XDG_CONFIG_HOME/git"
link_config "$DOTFILES/config/lf" "$XDG_CONFIG_HOME/lf"
link_config "$DOTFILES/config/npm" "$XDG_CONFIG_HOME/npm"
link_config "$DOTFILES/config/mycli/myclirc" "$XDG_CONFIG_HOME/myclirc"
link_config "$DOTFILES/config/xdg-user-dirs/user-dirs.dirs" "$XDG_CONFIG_HOME/user-dirs.dirs"
link_config "$DOTFILES/config/transmission" "$XDG_CONFIG_HOME/transmission-daemon"
link_config "$DOTFILES/config/newsboat" "$XDG_CONFIG_HOME/newsboat"
link_config "$DOTFILES/config/tmux" "$XDG_CONFIG_HOME/tmux"

# Tmux plugin manager (TPM)
[ ! -d "$XDG_CONFIG_HOME/tmux/plugins" ] &&
	git clone https://github.com/tmux-plugins/tpm "$XDG_CONFIG_HOME/tmux/plugins/tpm"

# GUI configurations
link_config "$DOTFILES/config/gui/alacritty" "$XDG_CONFIG_HOME/alacritty"
link_config "$DOTFILES/config/gui/zathura" "$XDG_CONFIG_HOME/zathura"
link_config "$DOTFILES/config/gui/gtk-3.0" "$XDG_CONFIG_HOME/gtk-3.0"
link_config "$DOTFILES/config/gui/gtk-2.0" "$XDG_CONFIG_HOME/gtk-2.0"
link_config "$DOTFILES/config/gui/jetbrains/ideavim" "$XDG_CONFIG_HOME/ideavim"
link_config "$DOTFILES/config/gui/Wayland/hypr" "$XDG_CONFIG_HOME/hypr"
link_config "$DOTFILES/config/gui/Wayland/waybar" "$XDG_CONFIG_HOME/waybar"
link_config "$DOTFILES/config/gui/Wayland/wofi" "$XDG_CONFIG_HOME/wofi"
link_config "$DOTFILES/config/gui/dunst" "$XDG_CONFIG_HOME/dunst"

# Desktop applications
mkdir -p "$XDG_DATA_HOME/applications"
cp -r "$DOTFILES/config/applications/"* "$XDG_DATA_HOME/applications/"

# MIME applications
link_config "$DOTFILES/config/mimeapps/mimeapps.list" "$XDG_CONFIG_HOME/mimeapps.list"
