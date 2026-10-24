#!/bin/bash -eu

if [ "$#" -ne 0 ]
then
	echo "$0: this script takes no arguments" >&2
	exit 1
fi

sudo sh -c "echo 0x7fffffff > /proc/sys/kernel/shmmax"
cinelerra &
