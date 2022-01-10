#!/bin/bash

QUERY=$(echo "" | wofi --dmenu --p "Search")
if [ -n "$QUERY" ]; then
    $BROWSER "https://www.google.com/search?q=$QUERY"
fi
