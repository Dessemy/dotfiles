#!/usr/bin/env bash

dir="$HOME/.config/rofi"
theme='powermenu'

uptime="$(uptime -p | sed -e 's/up //g')"
host=$(hostname)

shutdown=' Shutdown'
reboot=' Reboot'
lock=' Lock'
suspend=' Suspend'
logout=' Logout'
yes=' Yes'
no=' No'

rofi_cmd() {
    rofi -dmenu \
        -p "$host" \
        -mesg "Uptime: $uptime" \
        -theme "${dir}/${theme}.rasi"
}

confirm_cmd() {
    rofi \
        -theme-str 'window {location: center; anchor: center; fullscreen: false; width: 250px;}' \
        -theme-str 'mainbox {children: [ "message", "listview" ];}' \
        -theme-str 'listview {columns: 2; lines: 1;}' \
        -theme-str 'element-text {horizontal-align: 0.5;}' \
        -theme-str 'textbox {horizontal-align: 0.5;}' \
        -dmenu \
        -p 'Confirmation' \
        -mesg 'Are you Sure?' \
        -theme "${dir}/${theme}.rasi"
}

confirm_exit() {
    echo -e "$yes\n$no" | confirm_cmd
}

run_rofi() {
    echo -e "$lock\n$suspend\n$logout\n$reboot\n$shutdown" | rofi_cmd
}

run_cmd() {
    selected="$(confirm_exit)"
    if [[ "$selected" == "$yes" ]]; then
        case $1 in
            --shutdown) systemctl poweroff ;;
            --reboot)   systemctl reboot ;;
            --suspend)  systemctl suspend ;;
            --logout)   hyprctl dispatch exit 0 ;;
        esac
    else
        exit 0
    fi
}

chosen="$(run_rofi)"
case "$chosen" in
    "$shutdown") run_cmd --shutdown ;;
    "$reboot")   run_cmd --reboot ;;
    "$lock")     hyprlock ;;
    "$suspend")  run_cmd --suspend ;;
    "$logout")   run_cmd --logout ;;
esac
