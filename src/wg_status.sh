#!/bin/bash -eu
if pidof wg-crypt-wiregu > /dev/null
then
	echo "wireguard is up"
else
	echo "wireguard is down"
fi
