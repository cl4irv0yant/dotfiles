source /etc/X11/xinit/xinitrc.d/50-systemd-user.sh
amixer sset Master 0%

xrdb -merge $DOTFILES/X11/.Xresources
xmodmap $DOTFILES/X11/xmodmap

exec i3

