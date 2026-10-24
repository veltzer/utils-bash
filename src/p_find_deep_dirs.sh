#!/bin/bash -eu

if [ "$#" -ne 0 ]
then
	echo "$0: this script takes no arguments" >&2
	exit 1
fi

# find directories of depth 4 (there shouldnt be any)
find -L . -mindepth 4 -type d > err_deep.txt
