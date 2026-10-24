#!/bin/bash -eu

if [ "$#" -ne 0 ]
then
	echo "$0: this script takes no arguments" >&2
	exit 1
fi

# Open a browswer on the local stuff
xdg-open "docs/index.html"
