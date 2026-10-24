#!/bin/bash -eu

if [ "$#" -ne 0 ]
then
	echo "$0: this script takes no arguments" >&2
	exit 1
fi

sudo ifconfig eth0 down
sudo ifdown eth0
sudo ifconfig eth1 down
sudo ifdown eth1
sudo ifup eth1=home-wireless
