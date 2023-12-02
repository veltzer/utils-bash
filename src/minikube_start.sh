#!/bin/bash -e

# We are passing "driver=docker" here but minikube will detect docker usually so it's not a must
minikube start --driver=docker
