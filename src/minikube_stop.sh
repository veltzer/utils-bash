#!/bin/bash -e

# there is no --keep-context flag to "minikube stop"
export KUBECONFIG="${HOME}/.minikube.config"
minikube stop 
