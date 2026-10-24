#!/bin/bash -eu

if [ "$#" -ne 0 ]
then
	echo "$0: this script takes no arguments" >&2
	exit 1
fi

find -L . -mindepth 4 -type f -not -perm 444 -exec chmod 444 '{}' \+
find -L . -maxdepth 3 -type d -not -perm 755 -exec chmod 755 '{}' \+
