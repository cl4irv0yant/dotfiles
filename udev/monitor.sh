
#!/bin/bash

# Declare monitor names based on your specific setup (you can find these using xrandr)
INTERNAL_OUTPUT="eDP-1"  # Usually the built-in monitor
EXTERNAL_OUTPUT=""  # Initialize variable to hold external monitor name

# Loop through lines in xrandr output
xrandr | grep " connected" | while read -r line ; do
    OUTPUT=$(echo $line | awk '{print $1}')
    if [ "$OUTPUT" != "$INTERNAL_OUTPUT" ]; then
        EXTERNAL_OUTPUT=$OUTPUT
    fi
done

# Decide what to do
if [ -z "$EXTERNAL_OUTPUT" ]; then  # if EXTERNAL_OUTPUT is empty
    # No external monitors found
    xrandr --output $INTERNAL_OUTPUT --auto
else
    # An external monitor was found
    # Place it above the internal one
    xrandr --output $INTERNAL_OUTPUT --auto --output $EXTERNAL_OUTPUT --auto --above $INTERNAL_OUTPUT
fi
