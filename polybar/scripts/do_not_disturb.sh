#!/bin/bash

if pgrep -x dunst >/dev/null; then
    if dunstctl is-paused; then
        echo ""  # Do Not Disturb icon
    else
        echo ""  # Bell icon
    fi
else
    echo ""  # Dunst is not running icon
fi

