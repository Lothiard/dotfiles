#!/bin/bash

# State files
pomo_timer_file="/tmp/pomo_timer"
pom_path="/tmp/pomodoro"
pause_file="/tmp/pomo_paused"

# Config variables
work_time=2400      # 40min
break_time=900      # 15min

work_prefix=" "
break_prefix="󰅶 "
pause_prefix=" "
msg_start=" Pom"

start_color="#cdd6f4"
break_color="#a6e3a1"
work_color="#f38ba8"
pause_color="#fab387"

break_command="notify-send -t 2500 'Grab a tea'"
work_command="notify-send -t 2500 'Time to work!'"
bell="$HOME/.config/i3/scripts/bell.wav"
bell_end="$HOME/.config/i3/scripts/bell_end.wav"

# Ensure pomo_timer file exists
[ -f "$pomo_timer_file" ] || echo "0" > "$pomo_timer_file"
pluto=$(cat "$pomo_timer_file")

# Button handling
case $BLOCK_BUTTON in
    1) # Start/Stop timer
        if [ -f "$pom_path" ]; then
            rm "$pom_path"
            rm -f "$pause_file"
        else
            echo w > "$pom_path"
            date +%s >> "$pom_path"
            rm -f "$pause_file"
        fi
        ;;
    3) # Pause/Resume timer
        if [ -f "$pause_file" ]; then
            # ---- RESUME ----
            read paused_sec paused_mode < "$pause_file"
            now=$(date +%s)
            case $paused_mode in
                w) dur=$work_time;;
                b) dur=$break_time;;
            esac
            new_start=$((now - (dur - paused_sec)))
            echo "$paused_mode" > "$pom_path"
            echo "$new_start" >> "$pom_path"
            rm -f "$pause_file"
        else
            # ---- PAUSE ----
            if [ -f "$pom_path" ] && [ "$(wc -l $pom_path | awk '{print $1}')" -eq 2 ]; then
                p=$(sed '1 d' $pom_path)
                t=$(sed '2 d' $pom_path)
                now=$(date +%s)
                case $t in
                    w) dur=$work_time;;
                    b) dur=$break_time;;
                esac
                s=$((dur-now+p))
                echo "$s $t" > "$pause_file"
            fi
        fi
        ;;
esac

if [ "$pluto" -eq "0" ]; then
    echo "$msg_start"
    echo "$msg_start"
    echo "$start_color"
    exit 0
fi

if [ -f "$pause_file" ]; then
    read s t < "$pause_file"
    min=$((s/60))
    sek=$((s%60))
    [ $min -lt 10 ] && min="0$min"
    [ $sek -lt 10 ] && sek="0$sek"
    case $t in
        w)
            echo "$pause_prefix$min:$sek"
            echo "paused"
            echo "$pause_color"
            ;;
        b)
            echo "$pause_prefix$min:$sek"
            echo "paused"
            echo "$pause_color"
            ;;
    esac
    exit 0
fi

if [ -f "$pom_path" ] && [ "$(wc -l $pom_path | awk '{print $1}')" -eq 2 ]; then
    p=$(sed '1 d' "$pom_path")
    t=$(sed '2 d' "$pom_path")
    case $t in
        w) dur=$work_time;;
        b) dur=$break_time;;
    esac
    now=$(date +%s)
    s=$((dur-now+p))
    if [ $s -le 0 ]; then
        case $t in
            w)
                echo b > "$pom_path"
                eval "$break_command"
                paplay "$bell"
                ;;
            b)
                echo w > "$pom_path"
                eval "$work_command"
                paplay "$bell_end"
                ;;
        esac
        echo "$now" >> "$pom_path"
        s=$dur
    fi
    min=$((s/60))
    sek=$((s%60))
    [ $min -lt 10 ] && min="0$min"
    [ $sek -lt 10 ] && sek="0$sek"
    case $t in
        w)
            echo "$work_prefix$min:$sek"
            echo "$min:$sek"
            echo "$work_color"
            ;;
        b)
            echo "$break_prefix$min:$sek"
            echo "$min:$sek"
            echo "$break_color"
            ;;
    esac
else
    echo "$msg_start"
    echo "$msg_start"
    echo "$start_color"
fi
