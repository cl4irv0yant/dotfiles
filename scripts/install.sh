#!/bin/bash

echo "Bootstrap script"

set -euo pipefail

source "config/zsh/.zshenv"

if [ -d "$DOTFILES/bin" ] && [ -d "$DOTFILES/config" ] && [ -f "$DOTFILES/Makefile" ]; then
	echo "Dotfiles are correctly located at $DOTFILES."
else
	mkdir -p "$DOTFILES"
	echo "Dotfiles not found or incomplete at $DOTFILES."
	ORIGINAL="$(pwd)"
	rsync -av . "$DOTFILES"
	echo "Dotfiles installed at $DOTFILES."
	cd "$DOTFILES"
	rm -rf "$ORIGINAL"
fi

mkdir -p "$XDG_CONFIG_HOME"
mkdir -p "$XDG_DATA_HOME"

link_config() {
	local src=$1 dst=$2
	rm -rf "$dst"
	ln -sf "$src" "$dst"
}

rm -rf "$ZDOTDIR"
mkdir -p "$ZDOTDIR"
link_config "$DOTFILES/config/zsh/.zshenv" "$HOME/.zshenv"
link_config "$DOTFILES/config/zsh/.zshrc" "$ZDOTDIR/.zshrc"
link_config "$DOTFILES/config/zsh/aliases" "$ZDOTDIR/aliases"
link_config "$DOTFILES/config/zsh/external" "$ZDOTDIR/external"
link_config "$DOTFILES/config/zsh/scripts" "$ZDOTDIR/scripts"

PLUGIN_DIR="$ZDOTDIR/plugins"

if [ ! -d "$PLUGIN_DIR" ]; then
	mkdir "$PLUGIN_DIR"
fi

if [ ! -d "$PLUGIN_DIR/zsh-syntax-highlighting" ]; then
	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$PLUGIN_DIR/zsh-syntax-highlighting"
fi

if [ ! -d "$PLUGIN_DIR/zsh-autosuggestions" ]; then
	git clone https://github.com/zsh-users/zsh-autosuggestions.git "$PLUGIN_DIR/zsh-autosuggestions"
fi

echo "Plugins installed. Please ensure your .zshrc is configured to source them."

link_config "$DOTFILES/config/nvim" "$XDG_CONFIG_HOME/nvim"
link_config "$DOTFILES/config/git" "$XDG_CONFIG_HOME/git"
link_config "$DOTFILES/config/lf" "$XDG_CONFIG_HOME/lf"
link_config "$DOTFILES/config/npm" "$XDG_CONFIG_HOME/npm"
link_config "$DOTFILES/config/mycli/myclirc" "$XDG_CONFIG_HOME/myclirc"
link_config "$DOTFILES/config/xdg-user-dirs/user-dirs.dirs" "$XDG_CONFIG_HOME/user-dirs.dirs"

rm -rf "$XDG_CONFIG_HOME/transmission-daemon"
mkdir "$XDG_CONFIG_HOME/transmission-daemon"
link_config "$DOTFILES/config/transmission/settings.json" "$XDG_CONFIG_HOME/transmission-daemon/settings.json"
link_config "$DOTFILES/config/newsboat" "$XDG_CONFIG_HOME/newsboat"
link_config "$DOTFILES/config/pulsemixer" "$XDG_CONFIG_HOME/pulsemixer"

link_config "$SYNC/dotfiles/tmuxp" "$XDG_CONFIG_HOME/tmuxp"
link_config "$DOTFILES/config/tmux" "$XDG_CONFIG_HOME/tmux"

if [ ! -d "$XDG_DATA_HOME/tmux" ]; then
	mkdir "$XDG_DATA_HOME/tmux"
fi
[ ! -d "$XDG_DATA_HOME/tmux/plugins" ] &&
	git clone https://github.com/tmux-plugins/tpm "$XDG_DATA_HOME/tmux/plugins/tpm"

link_config "$DOTFILES/config/gui/dunst" "$XDG_CONFIG_HOME/dunst"
link_config "$DOTFILES/config/gui/alacritty" "$XDG_CONFIG_HOME/alacritty"
link_config "$DOTFILES/config/gui/zathura" "$XDG_CONFIG_HOME/zathura"
link_config "$DOTFILES/config/gui/gtk-3.0" "$XDG_CONFIG_HOME/gtk-3.0"
link_config "$DOTFILES/config/gui/gtk-2.0" "$XDG_CONFIG_HOME/gtk-2.0"
link_config "$DOTFILES/config/gui/jetbrains/ideavim" "$XDG_CONFIG_HOME/ideavim"

link_config "$DOTFILES/config/gui/Wayland/hypr" "$XDG_CONFIG_HOME/hypr"
link_config "$DOTFILES/config/gui/Wayland/waybar" "$XDG_CONFIG_HOME/waybar"
link_config "$DOTFILES/config/gui/Wayland/wofi" "$XDG_CONFIG_HOME/wofi"

link_config "$DOTFILES/config/gui/Xorg/i3" "$XDG_CONFIG_HOME/i3"
link_config "$DOTFILES/config/gui/Xorg/rofi" "$XDG_CONFIG_HOME/rofi"
link_config "$DOTFILES/config/gui/Xorg/polybar" "$XDG_CONFIG_HOME/polybar"
link_config "$DOTFILES/config/gui/Xorg/X11" "$XDG_CONFIG_HOME/X11"

mkdir -p "$XDG_DATA_HOME/applications"
cp -r "$DOTFILES/config/applications/"* "$XDG_DATA_HOME/applications/"

link_config "$DOTFILES/config/mimeapps/mimeapps.list" "$XDG_CONFIG_HOME/mimeapps.list"
