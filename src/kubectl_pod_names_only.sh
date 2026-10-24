#!/bin/bash -eu

# print out only the names of all current pods
#
# References:
# - https://stackoverflow.com/questions/35797906/kubernetes-list-all-running-pods-name

if [ "$#" -ne 0 ]
then
	echo "$0: this script takes no arguments" >&2
	exit 1
fi

kubectl get pods --template '{{range .items}}{{.metadata.name}}{{"\n"}}{{end}}'
