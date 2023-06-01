#!/bin/bash

echo "Updating system and installing necessary packages..."
sudo pacman -Syu xf86-input-libinput

DEVICE_ID=$(xinput list --id-only 'VEN_04F3:00 04F3:311C Touchpad')

echo "Enabling tap to click..."
xinput set-prop $DEVICE_ID 'libinput Tapping Enabled' 1

echo "Making changes permanent..."
echo 'Section "InputClass"
    Identifier "tap"
    MatchIsTouchpad "on"
    Option "Tapping" "on"
    Driver "libinput"
EndSection' | sudo tee /etc/X11/xorg.conf.d/40-libinput.conf > /dev/null

echo "Changes applied successfully. Please reboot your system to make sure changes persist."

