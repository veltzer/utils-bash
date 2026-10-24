#!/bin/bash -eu

if [ "$#" -ne 0 ]
then
	echo "$0: this script takes no arguments" >&2
	exit 1
fi

# this checks that the files are of the right type
find by_name -mindepth 2 -and -type f -and -not -name "*.avi" -and -not -name "*.m4v" -and -not -name "*.mp4" -and -not -name "*.mkv" -and -not -name "*.wmv" -and -not -name "*.flv" -and -not -name "*.mov" -and -not -name "*.webm"
# find by_name -mindepth 2 -and -type f -and -not -name "*.mp4"
