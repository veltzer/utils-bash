#!/bin/bash -eu

: <<'COMMENT'

This script turns pulse audio back on

COMMENT

if [ "$#" -ne 0 ]
then
	echo "$0: this script takes no arguments" >&2
	exit 1
fi

rm -f ~/.pulse/client.conf
pulseaudio --start
