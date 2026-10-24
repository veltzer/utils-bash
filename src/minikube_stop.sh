#!/bin/bash -eu

if [ "$#" -ne 0 ]
then
	echo "$0: this script takes no arguments" >&2
	exit 1
fi

# there is no --keep-context flag to "minikube stop"
export KUBECONFIG="${HOME}/.minikube.config"
minikube stop 
