#!/bin/bash

ACTIVE_VPN=$(ssh root@192.168.1.1 'wg' | grep 'interface' | awk '{print $2}')

CONFIGS=($(ssh root@192.168.1.1 'ls /usr/local/etc/wireguard' | sed 's/.conf//g'))

VPN=$(printf '%s\n' "${CONFIGS[@]}" | rofi -dmenu -p "Select a VPN:")

if [ "$VPN" ]; then
    echo "Starting $VPN"
    [ ! -z "$ACTIVE_VPN" ] && ssh root@192.168.1.1 "wg-quick down $ACTIVE_VPN"
    ssh root@192.168.1.1 "wg-quick up $VPN"
else
    echo "No VPN selected"
fi

