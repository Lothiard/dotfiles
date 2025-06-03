#!/bin/bash

SSID=$(iwgetid -r)
ICON=""

disconnected_color="#f38ba8"

case "$BLOCK_BUTTON" in
    1)
        # Open nmtui in a floating alacritty terminal
        i3-msg exec --no-startup-id alacritty --class nmtui -e nmtui &
        exit
        ;;
esac

if [ -z "$SSID" ]; then
    echo "$ICON  Disconnected"
    echo ""
    echo "$disconnected_color"
else
    echo "$ICON  $SSID"
fi
