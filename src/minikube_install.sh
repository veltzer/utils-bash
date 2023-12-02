#!/bin/bash -e

# first lets check that we have kubernetes (kubectl) in our path
if ! hash "kubectl" 2> /dev/null
then
	echo "cant find kubernetes (kubectl)"
	exit 1
else
	echo "have kubectl, good"
fi

# this
#	$ sudo apt install minikube
# is not the right way to install minikube on ubuntu
echo "TBD"
