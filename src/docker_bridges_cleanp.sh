#!/bin/bash -eu

# This script cleans up after docker
# Use it after
# $ sudo systemctl stop docker.service
# because it leaves bridge interfaces which it does not clean up

if [ "$#" -ne 0 ]
then
	echo "$0: this script takes no arguments" >&2
	exit 1
fi

for x in $(ip -br link show type bridge | tr -s " " | cut -f 1 -d " ")
do
	sudo ip link del "${x}"
done
