#!/usr/bin/env bash

laptop_monitor=$(xrandr | awk '/ connected/ && /eDP-/ {print $1}' | head -n 1)
external_monitor=$(xrandr | awk '/ connected/ && /DP-/ {print $1}' | tail -n 1)

xrandr --output "$external_monitor" --off
xrandr --output "$laptop_monitor" --primary --mode 3840x2400

