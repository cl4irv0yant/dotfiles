#!/bin/bash

# Variables
NAS_IP="192.168.1.111"
NAS_SHARE="/mnt/pool"
LOCAL_MOUNT_POINT="/mnt/truenas_backup"
FSTAB_FILE="/etc/fstab"
BACKUP_SRC="$HOME/backup"
BACKUP_DEST="${LOCAL_MOUNT_POINT}/"

# Step 1: Create the local mount point
if [ ! -d "$LOCAL_MOUNT_POINT" ]; then
    echo "Creating local mount point..."
    sudo mkdir -p "$LOCAL_MOUNT_POINT"
fi

# Step 2: Add the mount to fstab
if ! grep -q "$NAS_SHARE" "$FSTAB_FILE"; then
    echo "Adding NFS mount to fstab..."
    echo "${NAS_IP}:${NAS_SHARE} ${LOCAL_MOUNT_POINT} nfs defaults 0 0" | sudo tee -a "$FSTAB_FILE"
fi

# Step 3: Mount all from fstab
echo "Mounting all filesystems from fstab..."
sudo mount -a

# Step 4: Perform the backup
if mountpoint -q "$LOCAL_MOUNT_POINT"; then
    echo "Starting rsync backup..."
    sudo rsync -avh --delete "${BACKUP_SRC}/" "${BACKUP_DEST}"
    echo "Backup complete."
else
    echo "Error: Mount point is not mounted."
    exit 1
fi
