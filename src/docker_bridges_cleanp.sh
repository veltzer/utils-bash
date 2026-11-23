#!/bin/bash -eu

# This script cleans up after docker
# Use it after
# $ sudo systemctl stop docker.service
# because it leaves bridge interfaces which it does not clean up

if [[ "$#" -ne 0 ]]
then
	echo "$0: this script takes no arguments" >&2
	exit 1
fi

bridges=$(ip -br link show type bridge)
readarray -t bridge_lines <<< "${bridges}"
for line in "${bridge_lines[@]}"
do
	x=${line%% *}
	if [[ -n "${x}" ]]
	then
		sudo ip link del "${x}"
	fi
done
