#!/bin/bash -eu

if [ "$#" -ne 0 ]
then
	echo "$0: this script takes no arguments" >&2
	exit 1
fi

sudo systemctl stop snapd.service snapd.socket
sudo systemctl disable snapd.service snapd.socket
sudo systemctl mask snapd.service snapd.socket
