#!/bin/bash -e

if systemctl is-active --quiet docker.socket
then
	echo "docker.socket is up, stopping it"
	sudo systemctl --quiet stop docker.socket
else
	echo "docker.socket is down. Good"
fi

if systemctl is-active --quiet docker.service
then
	echo "docker.service is up, stopping it"
	sudo systemctl --quiet stop docker.service
else
	echo "docker.service is down. Good"
fi

if systemctl is-active --quiet containerd.service
then
	echo "containerd.service is up, stopping it"
	sudo systemctl --quiet stop containerd.service
else
	echo "containerd.service is down. Good"
fi

if ip link show docker0 &> /dev/null
then
	echo "docker0 device is up, deleting it"
	sudo ip link delete docker0
else
	echo "no docker0 device. Good"
fi

if systemctl is-active --quiet docker.service
then
	status="up"
else
	status="down"
fi
echo "docker is [${status}]"
