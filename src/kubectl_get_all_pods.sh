#!/bin/bash -eu

# This script shows all pods in kubernetes

if [ "$#" -ne 0 ]
then
	echo "$0: this script takes no arguments" >&2
	exit 1
fi

kubectl get pods --all-namespaces
