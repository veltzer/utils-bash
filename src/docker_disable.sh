#!/bin/bash -eu

if [ "$#" -ne 0 ]
then
	echo "$0: this script takes no arguments" >&2
	exit 1
fi

# disable all docker related services
sudo systemctl disable docker.socket
sudo systemctl disable docker.service containerd.service
