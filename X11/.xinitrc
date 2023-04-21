xrdb -merge $HOME/.config/X11/.Xresources
urxvtd -o -q -f
udiskie &

mkdir -p "$HOME"/.local/share/keyrings

source /etc/X11/xinit/xinitrc.d/50-systemd-user.sh

setxkbmap -option 'caps:ctrl_modifier';xcape -e 'Caps_Lock=Escape'&
setxkbmap se
setxkbmap -option caps:escape

exec i3
