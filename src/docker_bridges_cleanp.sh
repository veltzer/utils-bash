#!/bin/bash -e

# This script cleans up after docker
# Use it after
# $ sudo systemctl stop docker.service
# because it leaves bridge interfaces which it does not clean up

for x in $(ip -br link show type bridge | tr -s " " | cut -f 1 -d " ")
do
	sudo ip link del "${x}"
done
