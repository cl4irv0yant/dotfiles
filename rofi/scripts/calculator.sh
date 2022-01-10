#!/bin/bash

INPUT=$(wofi --dmenu --p "Calc" -lines 0)
if [ -n "$INPUT" ]; then
    RESULT=$(echo "scale=2; $INPUT" | bc -l 2>/dev/null)
    if [ $? -ne 0 ]; then
        wofi --e "Error in calculation."
    else
        echo "$RESULT" | wofi --dmenu --p "Result"
    fi
fi
