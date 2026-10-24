#!/bin/bash -eu

if [ "$#" -ne 0 ]
then
	echo "$0: this script takes no arguments" >&2
	exit 1
fi

# enable all docker related services
sudo systemctl enable docker.socket docker.service containerd.service
