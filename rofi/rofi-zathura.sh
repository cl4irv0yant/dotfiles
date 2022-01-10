#!/bin/bash

pdf_dir="$STATE/Books"

# Create an associative array
declare -A files

# Populate the array with filenames as keys and full paths as values
while IFS= read -r -d '' path; do
    files["$(basename "$path")"]="$path"
done < <(find "$pdf_dir" -type f -name "*.pdf" -print0 2>/dev/null)

# Pipe only the filenames to rofi
selected_pdf=$(printf '%s\n' "${!files[@]}" | rofi -dmenu -i -p "Select a PDF")

# Use the selected filename to get the corresponding full path
if [ -n "$selected_pdf" ]; then
    selected_pdf_path="${files[$selected_pdf]}"
    zathura "$selected_pdf_path" &
fi

