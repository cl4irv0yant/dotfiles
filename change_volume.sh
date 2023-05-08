
#!/bin/bash

# Set the path to the sound file
VOLUME_CHANGE_SOUND=~/sounds/volume_change.wav

# Check for input argument
if [ -z "$1" ]; then
    echo "Usage: change_volume.sh [up|down|mute]"
    exit 1
fi

# Perform the volume change
case $1 in
    up)
        pactl set-sink-volume @DEFAULT_SINK@ +5%
        ;;
    down)
        pactl set-sink-volume @DEFAULT_SINK@ -5%
        ;;
    mute)
        pactl set-sink-mute @DEFAULT_SINK@ toggle
        ;;
    *)
        echo "Invalid argument: $1"
        exit 1
        ;;
esac

# Play the volume change sound
# paplay $VOLUME_CHANGE_SOUND

volume_level=$(pactl list sinks | awk '/Volume: front-left/{ print $5 }' | head -n 1)
mute_status=$(pactl list sinks | awk '/Mute/{ print $2 }' | head -n 1)
# Show the volume notification
#  dunstify -t 1000 -r 5555 -u low "Volume: $volume_level, Mute: $mute_status"
(
echo "100"
) | zenity --progress --title="Volume" --text="Volume: $volume_level, Mute: $mute_status" --percentage=0 --auto-close --no-cancel --width=300 --height=100 2>/dev/null
