#!/bin/bash

# We use ssh to get the active VPN from the router
ACTIVE_VPN=$(ssh root@192.168.1.1 'wg' | grep 'interface' | awk '{print $2}')

# Get all WireGuard configurations and store them in an array
CONFIGS=($(ssh root@192.168.1.1 'ls /usr/local/etc/wireguard' | sed 's/.conf//g'))

# Use rofi to select a config
VPN=$(printf '%s\n' "${CONFIGS[@]}" | rofi -dmenu -p "Select a VPN:")

# If a config is selected, stop the currently running VPN and start the selected one.
# Again, we use ssh to send commands to the router
if [ "$VPN" ]; then
    echo "Starting $VPN"
    [ ! -z "$ACTIVE_VPN" ] && ssh root@192.168.1.1 "wg-quick down $ACTIVE_VPN"
    ssh root@192.168.1.1 "wg-quick up $VPN"
else
    echo "No VPN selected"
fi

