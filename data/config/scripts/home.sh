#!/bin/sh
{
xrandr --output HDMI-2 --off --output HDMI-1 --mode 1920x1080 --pos 0x0 --rotate normal --output DP-1 --off --output eDP-1 --off --output DP-2 --off && feh -F "~/dotfiles/config/wallpaper/wallpaper.png" --bg-fill &
intellij-idea-ultimate-edition &
firefox-developer &
telegram-desktop &
thunderbird &
spotify &
} &> /dev/null
