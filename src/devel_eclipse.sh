#!/bin/bash -eu

if [ "$#" -ne 0 ]
then
	echo "$0: this script takes no arguments" >&2
	exit 1
fi

~/install/eclipse-javascript/eclipse -data ~/workspace-javascript 1> /dev/null 2> /dev/null &
