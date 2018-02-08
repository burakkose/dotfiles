#!/bin/sh
{
xrandr --output eDP-1 --off --output DP-1-2 --primary --mode 1920x1200 --pos 0x0 --rotate right --output HDMI-2 --off --output HDMI-1 --off --output DP-1 --off --output DP-1-3 --off --output DP-2 --off --output DP-1-1 --mode 1920x1200 --pos 1200x344 --rotate normal
feh -F "~/dotfiles/config/wallpaper/wallpaper.png" --bg-fill &
intellij-idea-ultimate-edition &
firefox-developer &
telegram-desktop &
thunderbird &
spotify &
slack &
} &> /dev/null
