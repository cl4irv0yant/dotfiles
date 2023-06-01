source /etc/X11/xinit/xinitrc.d/50-systemd-user.sh
amixer sset Master 0%


xrdb -merge $HOME/.config/X11/.Xresources
exec i3


