#!/bin/bash -eu

if [ "$#" -ne 0 ]
then
	echo "$0: this script takes no arguments" >&2
	exit 1
fi

# this is for ps3 (dlna)
#ushare --dlna -c . --daemon
ushare --daemon --interface eth1 --content .
