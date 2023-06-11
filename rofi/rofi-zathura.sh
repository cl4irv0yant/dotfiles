#!/bin/bash

pdf_dir="$HOME/Documents/"

selected_pdf=$(find "$pdf_dir" -name "*.pdf" 2>/dev/null | rofi -dmenu -i -p "Select a PDF")
if [ -n "$selected_pdf" ]; then
    zathura "$selected_pdf" &
fi

