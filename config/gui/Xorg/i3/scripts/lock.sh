#!/bin/sh

img=~/dotfiles/i3/feh/lock.png

scrot -o $img
convert $img -scale 10% -scale 1000% $img

i3lock -u -i $img
