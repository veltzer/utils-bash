#!/bin/bash -eu

if [ "$#" -ne 0 ]
then
	echo "$0: this script takes no arguments" >&2
	exit 1
fi

# find regular files without .jpg extension
find -L . -mindepth 2 -type f -and -not -name "*.jpg" > err_jpg.txt
