#!/bin/bash

function gen_workspaces()
{
    xprop -root _NET_DESKTOP_NAMES | tr ',=' '\n' | grep '"' | sed 's/"//g'
}

WORKSPACES=gen_workspaces
WORKSPACE=$( $WORKSPACES  | rofi -dmenu -i -format i -p "Select workspace:")

if [ -n "${WORKSPACE}" ]
then
    wmctrl -s "${WORKSPACE}"
fi
