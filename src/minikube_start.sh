#!/bin/bash -e

# We are passing "driver=docker" here but minikube will detect docker usually so it's not a must
# the --keep-context is to keep minikube from overwriting ~/.kube/config
# there is no --kubeconfig flag to "minikube start"
export KUBECONFIG="${HOME}/.minikube.config"
minikube start --driver=docker
