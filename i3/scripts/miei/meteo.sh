#!/usr/bin/env bash

# Fetch weather
meteo=$(curl -s wttr.in/?format=1 | xargs echo)
first="${meteo%% *}"

# Map emoji to Nerd Font weather glyphs and colors
case "$first" in
    "☀️"|"☀")
        icon=""       # Sunny
        color="#f9e2af" # Warm yellow
        ;;
    "🌤️"|"🌤"|"⛅️"|"⛅")
        icon=" "       # Partly cloudy/sunny overcast
        color="#f5e0dc" # Soft orange
        ;;
    "🌦️"|"🌦")
        icon=" "       # Scattered showers
        color="#94e2d5" # Aqua/cyan
        ;;
    "🌧️"|"🌧")
        icon=" "       # Rain
        color="#89b4fa" # Blue
        ;;
    "☁️"|"☁")
        icon=" "       # Cloud
        color="#bac2de" # Light grey
        ;;
    "🌩️"|"🌩"|"⛈️"|"⛈")
        icon=" "       # Thunderstorm
        color="#fab387" # Orange (thunder)
        ;;
    "❄️"|"❄")
        icon=" "       # Snow
        color="#cdd6f4" # Pale blue
        ;;
    "🌫️"|"🌫")
        icon=" "       # Fog
        color="#a6adc8" # Muted grey
        ;;
    "🌙")
        icon=" "       # Night clear
        color="#f5c2e7" # Soft purple
        ;;
    *)
        icon="$first"
        color="#a6adc8" # Default muted
        ;;
esac

if [ -z "$meteo" ] || [ "$first" == "Unknown" ]; then
    echo "  Off"
else
    # Print the mapped icon with the rest of the text (drops the emoji)
    echo "${meteo#* } $icon"
    echo ""                # short_text line (optional)
    echo "$color"          # color for icon+text
fi
