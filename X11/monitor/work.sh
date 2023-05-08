
#!/bin/bash

# Variables
primary_output="eDP-1"
primary_mode="1920x1200"
primary_rate="60"
secondary_mode="1920x1080"
position="above"

# Functions
create_mode() {
  local output=$1
  local mode=$2

  modeline=$(cvt "${mode%x*}" "${mode#*x}" | sed -n '2s/.*Modeline //p')
  mode_name=$(echo "$modeline" | awk '{print $1}')

  if ! xrandr -q | grep -q "$mode_name"; then
    xrandr --newmode $modeline
    xrandr --addmode "$output" "$mode_name"
  fi

  echo "$mode_name"
}

remove_mode() {
  local output=$1
  local mode_name=$2

  xrandr --delmode "$output" "$mode_name"
  xrandr --rmmode "$mode_name"
}

set_output() {
  local output=$1
  mode_name=$(create_mode "$output" "$secondary_mode")
  xrandr --output "$output" --auto --output "$primary_output" --mode "$primary_mode" --rate "$primary_rate" --output "$output" --mode "$mode_name" --"$position" "$primary_output"
}

# Main
# Disable DPMS
xset -dpms

# Remove the created mode
if [ -n "$mode_name" ]; then
  for output in DP-1 DP-2 DP-3 DP-4; do
    remove_mode "$output" "$mode_name"
  done
fi

xrandr_output=$(xrandr -q)
if echo "$xrandr_output" | grep -q "DP-1 connected"; then
  set_output "DP-1"
elif echo "$xrandr_output" | grep -q "DP-2 connected"; then
  set_output "DP-2"
elif echo "$xrandr_output" | grep -q "DP-3 connected"; then
  set_output "DP-3"
elif echo "$xrandr_output" | grep -q "DP-4 connected"; then
  set_output "DP-4"
else
  echo "No external monitor detected."
fi

# Re-enable DPMS
xset +dpms

