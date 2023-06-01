
#!/bin/bash

# Set this to your obsidian vault directory
VAULT_DIR="$HOME/src/notes"

# Prompt for the note title, content and topic
TITLE=$(rofi -dmenu -p "Title")
CONTENT=$(xclip -selection clipboard -o)
TOPIC=$(rofi -dmenu -p "Topic")

# If title, content and topic are non-empty, create the file
if [ -n "$TITLE" ] && [ -n "$CONTENT" ] && [ -n "$TOPIC" ]; then
    # Create a unique filename based on the title
    FILENAME=$(echo "$TITLE" | sed -r 's/[^a-zA-Z0-9]+/-/g')_$(date +'%Y%m%d%H%M%S').md
    FILEPATH="$VAULT_DIR/$FILENAME"

    # Write the note to the file
    echo "$CONTENT" >> "$FILEPATH"
    echo "" >> "$FILEPATH"
    echo "---" >> "$FILEPATH"
    echo "type: #fleeting" >> "$FILEPATH"
    echo "topic: [[$TOPIC]]" >> "$FILEPATH"
fi
