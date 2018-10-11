#!/bin/sh
{
xrandr \
--output eDP-1 \
--off --output DP-1-2 \
--mode 2560x1440 \
--pos 2616x0 --rotate left --output HDMI-2 \
--off --output HDMI-1 \
--off --output DP-1 \
--off --output DP-1-3 \
--off --output DP-2 \
--off --output DP-1-1 \
--primary --mode 2560x1440 \
--pos 0x0 --rotate normal \
 && feh -F "$HOME/.config/wallpaper/wallpaper.png" --bg-fill \
 && (intellij-idea-community > /dev/null 2>&1 &) \
 && (firefox > /dev/null 2>&1 &) \
 && (spotify > /dev/null 2>&1 &)\
 && (amazon-chime > /dev/null 2>&1 &) \
 && (amazon-outlook > /dev/null 2>&1 &)
} &> /dev/null
