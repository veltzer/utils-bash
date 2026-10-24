#!/bin/bash -eu

if [ "$#" -ne 0 ]
then
	echo "$0: this script takes no arguments" >&2
	exit 1
fi

# run firefox with my private profile
firefox -P private 1> /dev/null 2> /dev/null &
