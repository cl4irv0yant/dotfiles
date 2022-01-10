#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

cp /usr/lib/systemd/system/getty@.service /usr/lib/systemd/system/getty@.service.bak

mkdir -p /etc/systemd/system/getty@tty1.service.d

echo "[Service]
ExecStart=
ExecStart=-/usr/bin/agetty --autologin gud1 --noclear %I 38400 linux" > /etc/systemd/system/getty@tty1.service.d/override.conf

systemctl daemon-reload

systemctl restart getty@tty1.service

echo "Auto login setup completed successfully"
