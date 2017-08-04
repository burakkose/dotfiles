#!/bin/sh
{
xrandr --output eDP-1 --off --output DP-1-2 --mode 1920x1200 --pos 0x0 --rotate normal --output HDMI-2 --off --output HDMI-1 --off --output DP-1 --off --output DP-1-3 --mode 1920x1200 --pos 1920x0 --rotate normal --output DP-2 --off --output DP-1-1 --off &
feh -F "~/dotfiles/config/wallpaper/wallpaper.png" --bg-fill &
intellij-idea-ultimate-edition &
firefox &
slack &
telegram &
thunderbird &
google-chrome-stable &
urxvt &
spotify &
} &> /dev/null
