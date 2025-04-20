#!/bin/bash -e

# We are passing "driver=docker" here but minikube will detect docker usually so it's not a must
# the --keep-context is to keep minikube from overwriting ~/.kube/config
# there is no --kubeconfig flag to "minikube start"
# export KUBECONFIG="${HOME}/.minikube.config"
# on old ubuntu we need to add --driver=docker
# minikube start
minikube start --nodes 3
