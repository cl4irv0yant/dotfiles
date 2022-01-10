#!/usr/bin/env bash

CHOICE=$(echo -e "Lock\nShutdown\nReboot\nSuspend\nLogout" | wofi --dmenu -p "Choose Action")

case $CHOICE in
    Lock)
        betterlockscreen --off 5 -l
        ;;
    Shutdown)
        systemctl poweroff
        ;;
    Reboot)
        systemctl reboot
        ;;
    Suspend)
        systemctl suspend
        ;;
    Logout)
        loginctl terminate-session ${XDG_SESSION_ID-}
        ;;
esac

