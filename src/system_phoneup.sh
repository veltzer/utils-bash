#!/bin/bash -eu

if [ "$#" -ne 0 ]
then
	echo "$0: this script takes no arguments" >&2
	exit 1
fi

# put the phone on PCSUITE mode for this to work...
sudo ifdown eth0
sudo ifdown eth1
sudo pppd call gprs
