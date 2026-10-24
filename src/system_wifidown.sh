#!/bin/bash -eu

if [ "$#" -ne 0 ]
then
	echo "$0: this script takes no arguments" >&2
	exit 1
fi

sudo ifdown eth1=home-wireless
sudo ifconfig eth1 down
