#!/bin/bash -eu

# Show all resources in my kubernetes cluister

if [ "$#" -ne 0 ]
then
	echo "$0: this script takes no arguments" >&2
	exit 1
fi

kubectl get pods
kubectl get services
kubectl get deployments
kubectl get configmaps
kubectl get secrets
# kubectl api-resources --verbs=list --namespaced -o name | xargs -n 1 kubectl get --show-kind --ignore-not-found -n default
