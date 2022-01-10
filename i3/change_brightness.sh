#!/bin/bash

# Constants
BRIGHTNESS_INCREMENT="10%"
NOTIFICATION_ID=2594
NOTIFICATION_TIMEOUT=2000

# Functions
function change_brightness {
    if [ "$1" = "up" ]; then
        brightnessctl set $BRIGHTNESS_INCREMENT+ > /dev/null
    elif [ "$1" = "down" ]; then
        brightnessctl set $BRIGHTNESS_INCREMENT- > /dev/null
    else
        echo "Invalid argument: $1"
        exit 1
    fi
}

function get_current_brightness {
    brightness=$(brightnessctl get)
    max_brightness=$(brightnessctl max)
    echo $(( brightness * 100 / max_brightness )) # Calculate the brightness percentage
}

function create_brightness_bar {
    local brightness=$1
    local bar=""
    for i in $(seq 1 10); do
        if [ $i -le $(($brightness / 10)) ]; then
            bar="${bar}█"
        else
            bar="${bar}░"
        fi
    done
    echo $bar
}

function show_notification {
    local brightness=$1
    local bar=$2

    dunstify -i display-brightness -t $NOTIFICATION_TIMEOUT -r $NOTIFICATION_ID -u normal \
    "Brightness: $brightness% $bar"
}

# Main
if ! command -v brightnessctl &> /dev/null
then
    echo "brightnessctl could not be found"
    exit
fi

change_brightness $1
brightness=$(get_current_brightness)
bar=$(create_brightness_bar $brightness)
show_notification $brightness $bar

