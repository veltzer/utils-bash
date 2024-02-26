#!/bin/bash -e

# We are passing "driver=docker" here but minikube will detect docker usually so it's not a must
# the --keep-context is to keep minikube from overwriting ~/.kube/config
minikube start --driver=docker --keep-context
