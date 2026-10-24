#!/bin/bash -eu

if [ "$#" -ne 0 ]
then
	echo "$0: this script takes no arguments" >&2
	exit 1
fi

find -L . -type f | wc > stats_count.txt
find -L . -mindepth 3 -maxdepth 3 -type d | sort > stats_series.txt
find -L . -mindepth 2 -maxdepth 2 -type d | sort > stats_names.txt
du -h -s . > stats_du.txt
