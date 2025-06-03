#!/usr/bin/bash
COLOR_LOW="#cdd6f4"
COLOR_MED="#a6e3a1"
COLOR_HIGH="#fab387"
COLOR_CRIT="#f38ba8"

cpu_usage=$((100-$(vmstat 1 2|tail -1|awk '{print $15}')))

if (( cpu_usage < 30 )); then
    color="$COLOR_LOW"
elif (( cpu_usage < 60 )); then
    color="$COLOR_MED"
elif (( cpu_usage < 85 )); then
    color="$COLOR_HIGH"
else
    color="$COLOR_CRIT"
fi

echo " ${cpu_usage}%"
echo ""
echo "$color"

