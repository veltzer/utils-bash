#!/bin/bash -eu

: <<'COMMENT'

This will flip your screen via xrandr(1)

COMMENT

if [ $# -ne 1 ]
then
	echo "No screen id specified"
	echo "Screens are:"
	xrandr --listmonitors
	exit 1
fi

SCREEN_ID=$1
# xrandr --output "${SCREEN_ID}" --rotate left
xrandr --output "${SCREEN_ID}" --rotate right
# xrandr --output "${SCREEN_ID}" --rotate normal
