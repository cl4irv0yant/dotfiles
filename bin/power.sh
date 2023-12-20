#!/bin/bash

options="Lock\nSuspend"

selected_option=$(echo -e $options | wofi --show dmenu --lines 2 --width 100 --prompt "Power Menu")

case $selected_option in
    "Lock")
        swaylock -f -c 000000
        ;;
    "Suspend")
        swaylock -f -c 000000
        systemctl suspend
        ;;
    *)
        ;;
esac
