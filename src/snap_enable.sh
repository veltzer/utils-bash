#!/bin/bash -eu

if [ "$#" -ne 0 ]
then
	echo "$0: this script takes no arguments" >&2
	exit 1
fi

sudo systemctl unmask snapd.service
sudo systemctl unmask snapd.socket
sudo systemctl unmask snapd.seeded.service
sudo systemctl enable snapd.service
sudo systemctl enable snapd.socket
sudo systemctl enable snapd.seeded.service
