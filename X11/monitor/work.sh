
#!/bin/bash

xrandr --auto

xset dpms force off

# Get the names of the laptop and external monitors
laptop_monitor=$(xrandr | awk '/ connected/ && /eDP/ {print $1}' | head -n 1 )
external_monitor=$(xrandr | awk '/ connected/ && /DP/ {print $1}' | tail -n 1 )


# If both monitors are found, configure them
if [ -n "$laptop_monitor" ] && [ -n "$external_monitor" ]; then
    xrandr --output "$laptop_monitor" --primary --mode 1920x1200 --output "$external_monitor" --mode 1920x1080 --above "$laptop_monitor"
    xset dpms force on    

else
    echo "Unable to find the specified monitors."
fi

xset dpms force on
