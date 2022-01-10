#!/bin/bash

LOGFILE="$HOME/arch_backup_log.txt"

# Logging function for ease
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a $LOGFILE
}

# Check for any recent Arch News. Requires informantAUR.
informant check 2>&1 | tee -a $LOGFILE

# Upgrade the system
log "Upgrading the system..."
sudo pacman -Syu 2>&1 | tee -a $LOGFILE
notify-send "Arch Backup" "System upgrade completed."

# Deal with .pacnew and .pacsave files.
log "Checking for .pacnew and .pacsave files..."
files=$(find /etc -type f \( -name "*.pacnew" -o -name "*.pacsave" \))
if [[ -n "$files" ]]; then
    log "Found .pacnew and/or .pacsave files. Manual intervention required."
    notify-send "Arch Backup" "Found .pacnew and/or .pacsave files."
fi

# Check and restart processes with outdated libraries. Requires archlinux-contrib.
log "Checking services..."
checkservices 2>&1 | tee -a $LOGFILE
notify-send "Arch Backup" "Services check completed."

# Check for orphan packages
log "Checking for orphaned packages..."
orphans=$(pacman -Qtdq)
if [[ -n "$orphans" ]]; then
    log "Found orphaned packages:"
    log "$orphans"
    notify-send "Arch Backup" "Found orphaned packages. Check the log for details."
fi

# Check for foreign packages not present in the repositories
log "Checking for foreign packages..."
foreign=$(pacman -Qm)
if [[ -n "$foreign" ]]; then
    log "Found foreign packages:"
    log "$foreign"
    notify-send "Arch Backup" "Found foreign packages. Check the log for details."
fi

log "Backup process completed!"
notify-send "Arch Backup" "Backup process completed."

