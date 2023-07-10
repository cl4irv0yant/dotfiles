#!/bin/sh

state=$(acpi -b | awk '{print $3}' | sed 's/,//')
percent=$(acpi -b | awk '{print $4}' | sed 's/%//' | sed 's/,//')

if [ -z "$percent" ] || ! [ "$percent" -eq "$percent" ] 2>/dev/null; then
    echo "Error: Battery percentage not found or is not a number"
    exit 1
fi

if [ "$state" = "Charging" ]; then
    icon=""
elif [ $percent -ge 85 ]; then
    icon=""
elif [ $percent -ge 60 ]; then
    icon=""
elif [ $percent -ge 35 ]; then
    icon=""
elif [ $percent -ge 10 ]; then
    icon=""
else
    icon=""
fi

echo "$icon"

