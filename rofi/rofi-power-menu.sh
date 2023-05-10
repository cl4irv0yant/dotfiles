#!/bin/bash

option0="lock"
option1="logout"
option2="suspend"
option3="hibernate"
option4="reboot"
option5="shutdown"

options="$option0\n$option1\n$option2\n$option3\n$option4\n$option5"

selected="$(echo -e "$options" | rofi -lines 6 -dmenu -p "system")"
case $selected in
  $option0)
    betterlockscreen -l
    ;;
  $option1)
    i3-msg exit
    ;;
  $option2)
    betterlockscreen -l && systemctl suspend
    ;;
  $option3)
    betterlockscreen -l && systemctl hibernate
    ;;
  $option4)
    systemctl reboot
    ;;
  $option5)
    systemctl poweroff -i
    ;;
esac
