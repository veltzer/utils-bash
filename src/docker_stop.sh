#!/bin/bash -e

sudo systemctl --quiet stop docker.service containerd.service
sudo ip link delete docker0
if systemctl is-active --quiet docker.service
then
	status="up"
else
	status="down"
fi
echo "docker is [${status}]"
