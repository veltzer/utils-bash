#!/bin/bash -eu

if [ "$#" -ne 0 ]
then
	echo "$0: this script takes no arguments" >&2
	exit 1
fi

minikube status
# if systemctl is-active --quiet docker.service
# then
# 	if [ "$(docker ps -q -f name=minikube)" ]
# 	then
# 		minikube status
# 	else
# 		echo "minikube is not running"
# 	fi
# else
# 	echo "docker is down, please bring it up"
# fi
