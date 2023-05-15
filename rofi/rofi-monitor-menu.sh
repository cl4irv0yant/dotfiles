#!/bin/bash

# Options to be displayed
option0="home"
option1="default"
option2="work"

# Options passed into variable
options="$option0\n$option1\n$option2"

selected="$(echo -e "$options" | rofi -lines 3 -dmenu -p "monitor config")"
case $selected in
  $option0)
    sh $DOTFILES/scripts/monitor/home.sh && sh $DOTFILES/scripts/ui/feh.sh
    ;;
  $option1)
    sh $DOTFILES/scripts/monitor/default.sh && sh $DOTFILES/scripts/ui/feh.sh
    ;;
  $option2)
    sh $DOTFILES/scripts/monitor/work.sh && sh $DOTFILES/scripts/ui/feh.sh
    ;;
esac
