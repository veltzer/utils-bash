#!/bin/bash -eu

: <<'COMMENT'

This script shuts down pulse audio so you can do recording sessions

COMMENT

if [ "$#" -ne 0 ]
then
	echo "$0: this script takes no arguments" >&2
	exit 1
fi

echo "autospawn = no" > ~/.pulse/client.conf
pulseaudio --kill
