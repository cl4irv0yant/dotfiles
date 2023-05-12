#!/bin/bash

# Change the volume using amixer
if [ "$1" = "up" ]; then
    amixer set Master 5%+ > /dev/null
elif [ "$1" = "down" ]; then
    amixer set Master 5%- > /dev/null
elif [ "$1" = "mute" ]; then
    amixer set Master toggle > /dev/null
fi

# Get the current volume and whether or not it's muted
volume=$(amixer get Master | grep -o "[0-9]*%" | head -1)
volume=${volume::-1} # Remove the trailing %
muted=$(amixer get Master | grep -o "\[off\]" | head -1)

# Create the volume bar
bar=""
for i in $(seq 1 10); do
    if [ $i -le $(($volume / 10)) ]; then
        bar="${bar}█"
    else
        bar="${bar}░"
    fi
done

# Show a notification
if [ "$muted" = "[off]" ]; then
    dunstify -i audio-volume-muted -t 2000 -r 2593 -u normal "Volume muted"
else
    dunstify -i audio-volume-high -t 2000 -r 2593 -u normal \
    "Volume: $volume% $bar"
fi

