#!/bin/bash -e

if [ "$#" -ne 0 ]
then
	echo "$0: this script takes no arguments" >&2
	exit 1
fi

nohup jupyter notebook &
echo $! > /tmp/jupyter_pid
