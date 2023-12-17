#!/bin/bash -e

# Show all resources in my kubernetes cluister

kubectl get pods
kubectl get services
kubectl get deployments
kubectl get configmaps
kubectl get secrets
# kubectl api-resources --verbs=list --namespaced -o name | xargs -n 1 kubectl get --show-kind --ignore-not-found -n default
