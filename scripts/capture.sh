#!/bin/bash

# Config
NOTES_HOME="$NOTES_HOME"
JOURNAL_DIR="Journal"

FLEETING_NOTE_CHOICE="fleeting"
FLEETING_NOTE_TYPE="#fleeting"

CODE_SNIPPET_CHOICE="code"
CODE_SNIPPET_TYPE="#code"

URL_NOTE_CHOICE="url"

TASK_NOTE_CHOICE="task"
TASK_NOTE_TYPE="#task"

add_fleeting() {
    fleeting_title=$(echo '' | rofi -dmenu -p 'Fleeting note title')
    fleeting_content=$(echo '' | rofi -dmenu -p 'Fleeting note content')

    if [ -n "$fleeting_title" ] && [ -n "$fleeting_content" ]; then
        fleeting_file="$NOTES_HOME/$fleeting_title.md"
        echo -e "$fleeting_content\n---\ntype: $FLEETING_NOTE_TYPE" > "$fleeting_file"
        add_to_daily_note "$fleeting_title"
    fi
}

add_code_snippet() {
    file_name=$(echo '' | rofi -dmenu -p 'Filename for the code snippet')
    snippet_file="$NOTES_HOME/$file_name.md"
    language=$(echo '' | rofi -dmenu -p 'Language of the code')
    
    code_note_content="$(xclip -selection clipboard -o)"

    echo "\`\`\`$language" > "$snippet_file"

    echo -e "$code_note_content\`\`\`" >> "$snippet_file"
    

    echo -e "\n---\ntype: $CODE_SNIPPET_TYPE" >> "$snippet_file"
    add_to_daily_note "Code Snippet: $file_name"
}


add_url() {
    backlog="$NOTES_HOME/Backlog.md"
    echo "- [ ] $(xclip -o)" >> "$backlog"  # adds the clipboard contents

    url_count=$(grep -c '^\- \[ \] ' "$backlog")
    update_daily_note_count "URLs added today: $url_count"
}

add_task() {
    task add project:"$2" +"$3" priority:"$4" due:"$5" "$1"
}

add_to_daily_note() {
    daily_note="$NOTES_HOME/$JOURNAL_DIR/$(date +%Y-%m-%d).md"
    echo "- [[$1]]" >> "$daily_note"
}

update_daily_note_count() {
    daily_note="$NOTES_HOME/$JOURNAL_DIR/$(date +%Y-%m-%d).md"
    echo "$1" >> "$daily_note"
}

capture() {
    action=$(echo "$TASK_NOTE_CHOICE|$FLEETING_NOTE_CHOICE|$CODE_SNIPPET_CHOICE|$URL_NOTE_CHOICE" | rofi -dmenu -sep '|' -p 'What do you want to capture?')

    case "$action" in
        "$TASK_NOTE_CHOICE")
            task=$(echo '' | rofi -dmenu -p 'New Task')
            project=$(echo '' | rofi -dmenu -p 'Project')
            context=$(echo '' | rofi -dmenu -p 'Context')
            priority=$(echo 'L|M|H' | rofi -dmenu -sep '|' -p 'Priority')
            due_date=$(echo '' | rofi -dmenu -p 'Due Date (YYYY-MM-DD or other formats recognized by taskwarrior)')
            if [ -n "$task" ]; then
                add_task "$task" "$project" "$context" "$priority" "$due_date"
            fi
            ;;
        "$FLEETING_NOTE_CHOICE")
            add_fleeting
            ;;
        "$CODE_SNIPPET_CHOICE")
            add_code_snippet
            ;;
        "$URL_NOTE_CHOICE")
            add_url
            ;;
    esac
}

capture

