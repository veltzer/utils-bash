#!/bin/bash -eu

: <<'COMMENT'

This script will find folders with large amount of files in them

COMMENT

if [ "$#" -ne 0 ]
then
	echo "$0: this script takes no arguments" >&2
	exit 1
fi

find by_name -type d -exec sh -c 'set -- "$0"/*.mp3; [ $# -ge 100 ]' {} \; -print
