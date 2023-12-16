#!/bin/bash -e

# Show all resources in my kubernetes cluister

kubectl api-resources --verbs=list --namespaced -o name | xargs -n 1 kubectl get --show-kind --ignore-not-found -n ALL
