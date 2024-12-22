#!/bin/bash -e

: <<'COMMENT'

This will flip your screen via xrandr(1)

COMMENT

if [ $# -ne 1 ]
then
	echo "No screen id specified"
	exit 1
fi

SCREEN_ID=$1
xrandr --output "${SCREEN_ID}" --rotate inverted
# xrandr --output "${SCREEN_ID}" --rotate normal
