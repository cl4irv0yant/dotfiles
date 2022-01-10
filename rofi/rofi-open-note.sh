
#!/bin/bash

VAULT_PATH=$NOTES_HOME

OBSIDIAN_URL="obsidian://open?vault=notes&file="
OBSIDIAN_WORKSPACE="8"

find "$VAULT_PATH" -name "*.md" -exec basename {} \; | rofi -dmenu -i -p "Select Note" | while read -r note
do
  note_filename=$(python -c "import urllib.parse; print(urllib.parse.quote('''$note'''))")
  
  i3-msg workspace "$OBSIDIAN_WORKSPACE"
  xdg-open "${OBSIDIAN_URL}${note_filename}"
done

