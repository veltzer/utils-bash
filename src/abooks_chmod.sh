#!/bin/bash -eu

if [ "$#" -ne 0 ]
then
	echo "$0: this script takes no arguments" >&2
	exit 1
fi

find . -mindepth 2 -type f -and -not -perm 444 -exec chmod 444 "{}" \;
find . -mindepth 2 -type d -and -not -perm 775 -exec chmod 775 "{}" \;
