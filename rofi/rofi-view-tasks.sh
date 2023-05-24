
#!/bin/bash

tasks=$(task ls)

# Show tasks with Rofi
selected_task=$(echo "$tasks" | rofi -dmenu -i -p 'Tasks')

if [ ! -z "$selected_task" ]; then
    task_id=$(echo "$selected_task" | awk '{print $1}')
    task done "$task_id"
fi
