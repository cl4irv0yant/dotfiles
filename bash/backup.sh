SOURCE_DIR="/home/your_username/"  
TARGET_DIR="/mnt/your_external_drive/backup"  

DATE=$(date +%Y-%m-%d_%H%M%S)
BACKUP_FILE="$TARGET_DIR/my_backup_$DATE.tar.gz"

mkdir -p "$TARGET_DIR"

echo "Starting backup from $SOURCE_DIR to $BACKUP_FILE"
tar -czf "$BACKUP_FILE" "$SOURCE_DIR"


if [ $? -eq 0 ]; then
    echo "Backup successful!"
else
    echo "Backup failed!" >&2
    exit 1
fi


echo "Backup process completed."
