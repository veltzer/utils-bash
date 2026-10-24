#!/bin/bash -eu

if [ "$#" -ne 0 ]
then
	echo "$0: this script takes no arguments" >&2
	exit 1
fi

find -L . -maxdepth 3 -mindepth 3 -name "*not_here*" > err_not_here.txt
