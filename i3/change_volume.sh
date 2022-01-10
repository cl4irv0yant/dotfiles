#!/bin/bash

# Constants
VOLUME_INCREMENT="5%"
NOTIFICATION_ID=2593
NOTIFICATION_TIMEOUT=2000

# Functions
function change_volume {
    if [ "$1" = "up" ]; then
        amixer set Master $VOLUME_INCREMENT+ > /dev/null
    elif [ "$1" = "down" ]; then
        amixer set Master $VOLUME_INCREMENT- > /dev/null
    elif [ "$1" = "mute" ]; then
        amixer set Master toggle > /dev/null
    else
        echo "Invalid argument: $1"
        exit 1
    fi
}

function get_current_volume {
    volume=$(amixer get Master | grep -o "[0-9]*%" | head -1)
    echo ${volume::-1} # Remove the trailing %
}

function get_mute_status {
    echo $(amixer get Master | grep -o "\[off\]" | head -1)
}

function create_volume_bar {
    local volume=$1
    local bar=""
    for i in $(seq 1 10); do
        if [ $i -le $(($volume / 10)) ]; then
            bar="${bar}█"
        else
            bar="${bar}░"
        fi
    done
    echo $bar
}

function show_notification {
    local volume=$1
    local bar=$2
    local muted=$3

    if [ "$muted" = "[off]" ]; then
        dunstify -i audio-volume-muted -t $NOTIFICATION_TIMEOUT -r $NOTIFICATION_ID -u normal "Volume muted"
    else
        dunstify -i audio-volume-high -t $NOTIFICATION_TIMEOUT -r $NOTIFICATION_ID -u normal \
        "Volume: $volume% $bar"
    fi
}

# Main
if ! command -v amixer &> /dev/null
then
    echo "amixer could not be found"
    exit
fi

change_volume $1
volume=$(get_current_volume)
muted=$(get_mute_status)
bar=$(create_volume_bar $volume)
show_notification $volume $bar $muted

