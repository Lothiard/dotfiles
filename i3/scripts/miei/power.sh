#!/usr/bin/bash

status=$(upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep state | awk '{print $2}')
if [ "$status" = "charging" ] || [ "$status" = "fully-charged" ]; then
    ~/.config/i3/scripts/miei/power_charge.sh
    exit 0
fi

level=$(upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep percentage | grep -o "[0-9]*")
unit=20
vite=$(($level / $unit))

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
