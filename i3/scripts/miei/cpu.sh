#!/usr/bin/bash
COLOR_LOW="#a6e3a1"
COLOR_MED="#fab387"
COLOR_HIGH="#f38ba8"

cpu_usage=$((100 - $(vmstat 1 2 | tail -1 | awk '{print $15}')))

if ((cpu_usage < 30)); then
    color="$COLOR_LOW"
elif ((cpu_usage < 85)); then
    color="$COLOR_MED"
elif ((cpu_usage < 101)); then
    color="$COLOR_HIGH"
fi

echo " ${cpu_usage}%"
echo ""
echo "$color"
