#!/bin/bash

CHOICE=$(echo -e "Search Web\nLaunch App\nCalculator\nPower\nOpen Book" | wofi --dmenu -i -p "Choose Action" | tr '[:upper:]' '[:lower:]')

case $CHOICE in
  "search web")
    $ROFI_DIR/scripts/search.sh
    ;;
  "launch app")
    wofi --show drun
    ;;
  "calculator")
    $ROFI_DIR/scripts/calculator.sh
    ;;
  "power")
    $ROFI_DIR/scripts/power-menu.sh
    ;;
  "open book")
    $ROFI_DIR/scripts/open-book.sh
    ;;
  *)
    notify-send "No valid option selected."
    ;;
esac

