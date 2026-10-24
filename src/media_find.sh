#!/bin/bash -eu

if [ "$#" -ne 0 ]
then
	echo "$0: this script takes no arguments" >&2
	exit 1
fi

find . -mindepth 2 -type f -name "*.mp4" -or -name "*.avi" -or -name "*.AVI" -or -name "*.m4v" -or -name "*.mkv" -or -name "*.mp3"
