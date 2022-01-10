DOTFILES ?= $(shell echo $$DOTFILES)
XDG_CONFIG_HOME ?= $(shell echo $$XDG_CONFIG_HOME)
XDG_DATA_HOME ?= $(shell echo $$XDG_DATA_HOME)
ZDOTDIR ?= $(shell echo $$ZDOTDIR)
SYNC ?= $(shell echo $$SYNC)

all: x11 zsh alacritty tmuxp zathura picom gtk git redshift phpstorm nvim i3 polybar rofi dunst lf applications mimeapps xdg-user-dirs mycli tmux

x11:
	rm -rf $(XDG_CONFIG_HOME)/X11
	ln -s $(DOTFILES)/X11 $(XDG_CONFIG_HOME)/

zsh:
	ln -sf $(DOTFILES)/zsh/zshenv $(HOME)/.zshenv
	ln -sf $(DOTFILES)/zsh/zshrc $(ZDOTDIR)/.zshrc
	ln -sf $(DOTFILES)/zsh/aliases $(ZDOTDIR)/aliases
	ln -sf $(DOTFILES)/zsh/external $(ZDOTDIR)
	ln -sf $(DOTFILES)/zsh/scripts $(ZDOTDIR)

alacritty:
	rm -rf $(XDG_CONFIG_HOME)/alacritty
	ln -sf $(DOTFILES)/alacritty $(XDG_CONFIG_HOME)

tmuxp:
	rm -rf $(XDG_CONFIG_HOME)/tmuxp
	ln -sf $(SYNC)/dotfiles/tmuxp $(XDG_CONFIG_HOME)

zathura:
	rm -rf $(XDG_CONFIG_HOME)/zathura
	ln -s $(DOTFILES)/zathura $(XDG_CONFIG_HOME)

picom:
	rm -rf $(XDG_CONFIG_HOME)/picom
	ln -s $(DOTFILES)/picom $(XDG_CONFIG_HOME)

gtk:
	rm -rf $(XDG_CONFIG_HOME)/gtk-3.0
	ln -s $(DOTFILES)/gtk-3.0 $(XDG_CONFIG_HOME)
	rm -rf $(XDG_CONFIG_HOME)/gtk-2.0
	ln -s $(DOTFILES)/gtk-2.0 $(XDG_CONFIG_HOME)

git:
	rm -rf $(XDG_CONFIG_HOME)/git
	ln -s $(DOTFILES)/git $(XDG_CONFIG_HOME)

redshift:
	rm -rf $(XDG_CONFIG_HOME)/redshift
	ln -s $(DOTFILES)/redshift $(XDG_CONFIG_HOME)

phpstorm:
	rm -rf $(XDG_CONFIG_HOME)/ideavim
	ln -s $(DOTFILES)/jetbrains/ideavim $(XDG_CONFIG_HOME)

nvim:
	rm -rf $(XDG_CONFIG_HOME)/nvim
	ln -s $(DOTFILES)/nvim $(XDG_CONFIG_HOME)

i3:
	rm -rf $(XDG_CONFIG_HOME)/i3
	ln -s $(DOTFILES)/i3 $(XDG_CONFIG_HOME)

polybar:
	rm -rf $(XDG_CONFIG_HOME)/polybar
	ln -sf $(DOTFILES)/polybar $(XDG_CONFIG_HOME)

rofi:
	rm -rf $(XDG_CONFIG_HOME)/rofi
	ln -sf $(DOTFILES)/rofi $(XDG_CONFIG_HOME)

dunst:
	rm -rf $(XDG_CONFIG_HOME)/dunst
	ln -sf $(DOTFILES)/dunst $(XDG_CONFIG_HOME)

lf:
	rm -rf $(XDG_CONFIG_HOME)/lf
	ln -s $(DOTFILES)/lf $(XDG_CONFIG_HOME)

applications:
	rm -rf $(XDG_DATA_HOME)/applications
	ln -sf $(DOTFILES)/applications $(XDG_DATA_HOME)

mimeapps:
	ln -sf $(DOTFILES)/mimeapps/mimeapps.list $(XDG_CONFIG_HOME)/mimeapps.list

xdg-user-dirs:
	ln -sf $(DOTFILES)/xdg-user-dirs/user-dirs.dirs $(XDG_CONFIG_HOME)/user-dirs.dirs

mycli:
	ln -sf $(DOTFILES)/mycli/myclirc $(XDG_CONFIG_HOME)/myclirc

tmux:
	rm -rf $(XDG_CONFIG_HOME)/tmux && mkdir $(XDG_CONFIG_HOME)/tmux
	ln -sf $(DOTFILES)/tmux/tmux.conf $(XDG_CONFIG_HOME)/tmux/tmux.conf
	[ ! -d $(XDG_CONFIG_HOME)/tmux/plugins ] && \
	git clone https://github.com/tmux-plugins/tpm $(XDG_CONFIG_HOME)/tmux/plugins/tpm

.PHONY: all x11 zsh alacritty tmuxp zathura picom gtk git redshift phpstorm nvim i3 polybar rofi dunst lf applications mimeapps xdg-user-dirs mycli tmux

