
#!/usr/bin/env bash

xrandr --auto

xset dpms force off

# Get the names of the laptop and external monitors
laptop_monitor=$(xrandr | awk '/ connected/ && /eDP-/ {print $1}' | head -n 1 )
external_monitor=$(xrandr | awk '/ connected/ && /DP-/ {print $1}' | tail -n 1 )

# If both monitors are found, configure them
if [ -n "$laptop_monitor" ] && [ -n "$external_monitor" ]; then
    if xrandr --output "$laptop_monitor" --primary --mode 3840x2400 --output "$external_monitor" --mode 3840x2160 --above "$laptop_monitor"; then
        xset dpms force on
    else
        echo "xrandr failed to configure the monitors."
        exit 1
    fi
else
    echo "Unable to find the specified monitors."
    exit 1
fi

xset dpms force on

