#!/bin/bash

SYNC_DIR=$SYNC

if [ -z "$SYNC_DIR" ]; then
  echo "The SYNC directory is not set. Please set the SYNC environment variable."
  exit 1
fi

SELECTED_BOOK=$(find "$SYNC_DIR" -type f -iname '*.pdf' | wofi --dmenu --p "Open Book")

if [ -n "$SELECTED_BOOK" ]; then
  zathura "$SELECTED_BOOK" 2>/dev/null &
else
  echo "No book selected or Zathura encountered an error."
fi
