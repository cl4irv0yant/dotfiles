LOG_FILE="/home/gustaf/battery_check.log"
BATTERY_PATH=$(find /sys/class/power_supply/ -name 'BAT*' | head -n 1)
LOW_BATTERY=20


log_message() {
    echo "$(date) - $1" >> "$LOG_FILE"
}


if ! command -v notify-send &> /dev/null; then
    log_message "Error: notify-send not found."
    exit 1
fi


if [[ ! -d "$BATTERY_PATH" ]]; then
    log_message "Error: Battery path not found."
    exit 1
fi


CAPACITY=$(cat "${BATTERY_PATH}/capacity")
STATUS=$(cat "${BATTERY_PATH}/status")


if [[ "$STATUS" == "Discharging" ]] && [[ "$CAPACITY" -le "$LOW_BATTERY" ]]; then
    

    if XDG_RUNTIME_DIR=/run/user/$(id -u) notify-send -u critical "Battery low" "Capacity: ${CAPACITY}%"; then
        log_message "Notified low battery: ${CAPACITY}%"
    else
        log_message "Error: Failed to send notification."
    fi
fi

