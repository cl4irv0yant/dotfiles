#!/bin/bash

rofi -modi drun,run -show drun

##!/bin/bash
#
#option0="default"
#option1="external"
#
#options="$option0\n$option1"
#
#selected="$(echo -e "$options" | rofi -lines 2 -dmenu -p "monitor config")"
#case $selected in
#  $option0)
#    autorandr --load default;;
#  $option1)
#    autorandr --load work;;
#esac

#!/bin/bash

#VAULT_PATH=$NOTES_HOME
#
#OBSIDIAN_URL="obsidian://open?vault=notes&file="
#OBSIDIAN_WORKSPACE="8"
#
#find "$VAULT_PATH" -name "*.md" -exec basename {} \; | rofi -dmenu -i -p "Select Note" | while read -r note
#do
#  note_filename=$(python -c "import urllib.parse; print(urllib.parse.quote('''$note'''))")
#  
#  i3-msg workspace "$OBSIDIAN_WORKSPACE"
#  xdg-open "${OBSIDIAN_URL}${note_filename}"
#done
#

#
##!/bin/bash
#
#VAULT_DIR="$NOTES_HOME"
#
#TITLE=$(rofi -dmenu -p "Title")
#CONTENT=$(xclip -selection clipboard -o)
#TOPIC=$(rofi -dmenu -p "Topic")
#
#if [ -n "$TITLE" ] && [ -n "$CONTENT" ] && [ -n "$TOPIC" ]; then
#    FILENAME=$(echo "$TITLE" | sed -r 's/[^a-zA-Z0-9]+/-/g')_$(date +'%Y%m%d%H%M%S').md
#    FILEPATH="$VAULT_DIR/$FILENAME"
#
#    echo "$CONTENT" >> "$FILEPATH"
#    echo "" >> "$FILEPATH"
#    echo "---" >> "$FILEPATH"
#    echo "type: #fleeting" >> "$FILEPATH"
#    echo "topic: [[$TOPIC]]" >> "$FILEPATH"
#fi

##!/bin/bash
#
#pdf_dir="$SYNC/Books"
#
#declare -A files
#
#while IFS= read -r -d '' path; do
#    files["$(basename "$path")"]="$path"
#done < <(find "$pdf_dir" -type f -name "*.pdf" -print0 2>/dev/null)
#
## Pipe only the filenames to rofi
#selected_pdf=$(printf '%s\n' "${!files[@]}" | rofi -dmenu -i -p "Select a PDF")
#
## Use the selected filename to get the corresponding full path
#if [ -n "$selected_pdf" ]; then
#    selected_pdf_path="${files[$selected_pdf]}"
#    zathura "$selected_pdf_path" &
#fi

##!/bin/bash
#
#tasks=$(task ls)
#
#selected_task=$(echo "$tasks" | rofi -dmenu -i -p 'Tasks')
#
#if [ ! -z "$selected_task" ]; then
#    task_id=$(echo "$selected_task" | awk '{print $1}')
#    task done "$task_id"
#fi
