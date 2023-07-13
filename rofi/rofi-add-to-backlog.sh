#!/bin/bash
item=$(rofi -dmenu -p "Add to backlog")
echo "- [ ] $item" >> $NOTES_HOME/Backlog.md

