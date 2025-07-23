#!/usr/bin/bash

status=$(upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep state | awk '{print $2}')
if [ "$status" = "charging" ] || [ "$status" = "fully-charged" ]; then
    ~/.config/i3/scripts/miei/power_charge.sh
    exit 0
fi

level=$(upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep percentage | grep -o "[0-9]*")
unit=20
vite=$(($level / $unit))

NOTIFY_DIR="/tmp/battery_notifications"
NOTIFY_20="${NOTIFY_DIR}/notify_20"
NOTIFY_10="${NOTIFY_DIR}/notify_10"
NOTIFY_5="${NOTIFY_DIR}/notify_5"

mkdir -p "$NOTIFY_DIR"

if [ "$level" -le 20 ] && [ "$level" -gt 10 ] && [ ! -f "$NOTIFY_20" ]; then
    notify-send -u normal "Battery Low" "Battery is at ${level}%. Please consider charging." -i battery-low
    touch "$NOTIFY_20"
elif [ "$level" -gt 20 ] && [ -f "$NOTIFY_20" ]; then
    # Remove the notification file when above the threshold
    rm -f "$NOTIFY_20"
fi

if [ "$level" -le 10 ] && [ "$level" -gt 5 ] && [ ! -f "$NOTIFY_10" ]; then
    notify-send -u critical "Battery Very Low" "Battery is at ${level}%. Please charge now!" -i battery-caution
    touch "$NOTIFY_10"
elif [ "$level" -gt 10 ] && [ -f "$NOTIFY_10" ]; then
    rm -f "$NOTIFY_10"
fi

if [ "$level" -le 5 ] && [ ! -f "$NOTIFY_5" ]; then
    notify-send -u critical "Battery Critical" "Battery is at ${level}%. System will hibernate soon!" -i battery-empty
    touch "$NOTIFY_5"
elif [ "$level" -gt 5 ] && [ -f "$NOTIFY_5" ]; then
    rm -f "$NOTIFY_5"
fi

if [ "$vite" == 5 ]; then
    echo " $level%"
    echo ""
    echo "#cdd6f4"
fi

if [ "$vite" == 4 ]; then
    echo " $level%"
    echo ""
    echo "#a6e3a1"
fi

if [ "$vite" == 3 ]; then
    echo " $level%"
    echo ""
    echo "#a6e3a1"
fi

if [ "$vite" == 2 ]; then
    echo " $level%"
    echo ""
    echo "#fab387"
fi

if [ "$vite" == 1 ]; then
    echo " $level%"
    echo ""
    echo "#fab387"
fi

if [ "$level" -lt 20 ] && [ "$level" -ge 10 ]; then
    echo " $level%"
    echo ""
    echo "#f38ba8"
fi

if [ "$level" -lt 10 ]; then
    echo "! $level%"
    echo ""
    echo "#f38ba8"
fi
