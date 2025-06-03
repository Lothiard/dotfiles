#!/bin/bash

LOFI_URL="https://www.youtube.com/watch?v=jfKfPfyJRdk"

STATE_FILE="/tmp/lofi_on"

color="#a6e3a1"

if [[ "$BLOCK_BUTTON" == "1" ]]; then
    if [[ -f "$STATE_FILE" ]]; then
        killall mpv 2>/dev/null
        rm -f "$STATE_FILE"
    else
        nohup mpv --no-video --quiet "$LOFI_URL" >/dev/null 2>&1 &
        touch "$STATE_FILE"
    fi
fi

if [[ -f "$STATE_FILE" ]]; then
    echo "󰝚 󱁷 󰎇"
    echo ""
    echo "$color"
else
    echo "󱁶 lofi"
fi
