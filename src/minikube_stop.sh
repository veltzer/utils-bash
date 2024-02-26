#!/bin/bash -e

# the --keep-context is to keep minikube from overwriting ~/.kube/config
minikube stop --keep-context
