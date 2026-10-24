#!/bin/bash -eu

if [ "$#" -ne 0 ]
then
	echo "$0: this script takes no arguments" >&2
	exit 1
fi

# set -x
# you can add int_corsair
for x in ext_wd ext_wd_large ext_seagate
do
	ls -l "/mnt/${x}/mark/backups"
done
