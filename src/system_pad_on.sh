#!/bin/bash -eu

if [ "$#" -ne 0 ]
then
	echo "$0: this script takes no arguments" >&2
	exit 1
fi

xinput --set-prop "AlpsPS/2 ALPS DualPoint TouchPad" "Device Enabled" 1
