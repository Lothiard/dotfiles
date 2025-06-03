#!/usr/bin/env bash

SYSTEM76_POWER="/usr/bin/system76-power"
BRIGHTNESS_NORMAL="70%"

get_profile() {
    $SYSTEM76_POWER profile 2>/dev/null | grep "Power Profile" | awk -F': ' '{print tolower($2)}' | xargs
}

profile=$(get_profile)

case "$profile" in
    battery)      a=0 ;;
    balanced)     a=1 ;;
    performance)  a=2 ;;
    *)            a=0 ;;
esac

if [[ "$BLOCK_BUTTON" == "1" ]]; then
    case "$a" in
        0)
            $SYSTEM76_POWER profile balanced >/dev/null 2>&1
            brightnessctl set $BRIGHTNESS_NORMAL >/dev/null 2>&1
            ;;
        1)
            $SYSTEM76_POWER profile performance >/dev/null 2>&1
            brightnessctl set $BRIGHTNESS_NORMAL >/dev/null 2>&1
            ;;
        2)
            $SYSTEM76_POWER profile battery >/dev/null 2>&1
            # Optionally dim here: brightnessctl set 20% >/dev/null 2>&1
            ;;
    esac
    profile=$(get_profile)
fi

eco_c="#a6e3a1"
perf_c="#f38ba8"
blc_c="#fab387"

case "$profile" in
    battery)
        echo "  Eco"
        echo ""
        echo "$eco_c";;
    balanced)
        echo "  Blc"
        echo ""
        echo "$blc_c";;
    performance)
        echo "  Pro"
        echo ""
        echo "$perf_c";;
esac
