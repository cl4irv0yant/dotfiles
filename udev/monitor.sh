
#!/bin/bash

INTERNAL_OUTPUT="eDP-1" 
EXTERNAL_OUTPUT=""

xrandr | grep " connected" | while read -r line ; do
    OUTPUT=$(echo $line | awk '{print $1}')
    if [ "$OUTPUT" != "$INTERNAL_OUTPUT" ]; then
        EXTERNAL_OUTPUT=$OUTPUT
    fi
done

if [ -z "$EXTERNAL_OUTPUT" ]; then  
    autorandr --load default
else
    autorandr --load work
fi
