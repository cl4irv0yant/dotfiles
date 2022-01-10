#!/bin/bash

add_task() {
    task add "$1"
    echo "Task added: $1"
}

task=$(echo '' | rofi -dmenu -p 'New Task')

if [ ! -z "$task" ]; then
    add_task "$task"
fi
