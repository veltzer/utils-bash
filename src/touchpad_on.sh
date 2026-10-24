#!/bin/bash -eu

if [ "$#" -ne 0 ]
then
	echo "$0: this script takes no arguments" >&2
	exit 1
fi

xinput enable "PS/2 Generic Mouse" 2> /dev/null
xinput enable "AlpsPS/2 ALPS DualPoint TouchPad" 2> /dev/null
