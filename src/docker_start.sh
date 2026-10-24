#!/bin/bash -eu

if [ "$#" -ne 0 ]
then
	echo "$0: this script takes no arguments" >&2
	exit 1
fi

sudo systemctl start docker.service
if systemctl is-active --quiet docker.service
then
	status="up"
else
	status="down"
fi
echo "docker is [${status}]"
