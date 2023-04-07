#!/bin/bash -e

if systemctl is-active --quiet docker.service
then
	status="up"
else
	status="down"
fi
echo "docker is [${status}]"
