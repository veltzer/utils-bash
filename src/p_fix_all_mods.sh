#!/bin/bash -eu

if [ "$#" -ne 0 ]
then
	echo "$0: this script takes no arguments" >&2
	exit 1
fi

find -L . -type f -exec chmod 444 '{}' \+
find -L . -type d -exec chmod 755 '{}' \+
