#!/bin/bash -eu

if [ "$#" -ne 0 ]
then
	echo "$0: this script takes no arguments" >&2
	exit 1
fi

if pidof wg-crypt-wiregu > /dev/null
then
	echo "wireguard is up"
else
	echo "wireguard is down"
fi
