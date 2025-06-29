#!/bin/bash

# Station setup
STATIONS=(
    "https://www.youtube.com/watch?v=jfKfPfyJRdk"
    "https://www.youtube.com/watch?v=HuFYqnbVbzY"
    "https://www.youtube.com/watch?v=4xDzrJKXOOY"
)
ICONS=("󰝚" "󰘉" "󰖔")
LABELS=("lofi" "jazz" "synth")
COLORS=("#a6e3a1" "#fab387" "#7c7cff")

STATION_FILE="/tmp/lofi_station"

# Get or initialize station index
if [[ -f "$STATION_FILE" ]]; then
    idx=$(cat "$STATION_FILE")
else
    idx=0
fi
# Sanitize idx
if ! [[ "$idx" =~ ^[0-2]$ ]]; then
    idx=0
fi

# Helper: is mpv playing any of our streams?
is_playing() {
    pgrep -f "mpv --no-video --quiet" >/dev/null
}

# Left click: start/stop
if [[ "$BLOCK_BUTTON" == "1" ]]; then
    if is_playing; then
        pkill -f "mpv --no-video --quiet"
    else
        nohup mpv --no-video --quiet "${STATIONS[$idx]}" >/dev/null 2>&1 &
    fi
fi

# Right click: next station
if [[ "$BLOCK_BUTTON" == "3" ]]; then
    idx=$(((idx + 1) % ${#STATIONS[@]}))
    echo "$idx" >"$STATION_FILE"
    # If playing, stop all and start new stream
    if is_playing; then
        pkill -f "mpv --no-video --quiet"
        nohup mpv --no-video --quiet "${STATIONS[$idx]}" >/dev/null 2>&1 &
    fi
else
    echo "$idx" >"$STATION_FILE"
fi

# Block output
if is_playing; then
    echo "${ICONS[$idx]} ${LABELS[$idx]}"
    echo ""
    echo "${COLORS[$idx]}"
else
    echo "${ICONS[$idx]} ${LABELS[$idx]}"
    echo ""
    echo ""
fi
