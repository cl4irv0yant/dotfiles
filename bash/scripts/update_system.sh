#!/bin/bash

UPDATE_LOG="/home/gustaf/update.log"

log_message() {
    echo "$(date) - $1" >> "$UPDATE_LOG"
}

check_for_updates() {
    log_message "Checking for available system updates"
    # Check for updates (checkupdates is part of pacman-contrib package)
    UPDATES=$(checkupdates)

    if [ -z "$UPDATES" ]; then
        log_message "No updates available."
    else
        UPDATE_COUNT=$(echo "$UPDATES" | wc -l)
        log_message "There are $UPDATE_COUNT updates available."
        
        export DISPLAY=:0
        export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$(id -u)/bus"
        
        notify-send -u normal "Updates Available" "$UPDATE_COUNT packages can be updated:\n$UPDATES"
    fi
}

check_for_updates

