#!/bin/bash -e

# print out only the names of all current pods
#
# References:
# - https://stackoverflow.com/questions/35797906/kubernetes-list-all-running-pods-name

kubectl get pods --template '{{range .items}}{{.metadata.name}}{{"\n"}}{{end}}'
