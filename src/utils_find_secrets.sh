#!/bin/bash -eu

if [ "$#" -ne 0 ]
then
	echo "$0: this script takes no arguments" >&2
	exit 1
fi

# this is a simple script to find my secret folders
find . -type d -and -not -perm 775
