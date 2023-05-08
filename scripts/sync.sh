
#!/bin/bash

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <local_path> <remote_path>"
    exit 1
fi

LOCAL_PATH="$1"
REMOTE_PATH="$2"
rclone copy "$LOCAL_PATH" "$REMOTE_PATH"

rclone copy "$REMOTE_PATH" "$LOCAL_PATH"

DIFFS=$(rclone check "$LOCAL_PATH" "$REMOTE_PATH" --quiet)

if [ -n "$DIFFS" ]; then
    echo "There are differences between the local folder and Google Drive:"
    echo "$DIFFS"
fi
