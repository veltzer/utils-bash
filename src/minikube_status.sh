#!/bin/bash -e

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
