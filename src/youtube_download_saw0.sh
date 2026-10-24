#!/bin/bash -eu

if [ "$#" -ne 0 ]
then
	echo "$0: this script takes no arguments" >&2
	exit 1
fi

utils_hibernate_disable.sh
youtube-dl\
	https://www.youtube.com/playlist?list=PLZHKR1yYunFQ3ciN2kHYg5y7YjKZUjMey\
	--continue\
	--ignore-errors
utils_hibernate_enable.sh
