#!/bin/bash -eu

if [ "$#" -ne 0 ]
then
	echo "$0: this script takes no arguments" >&2
	exit 1
fi

find -L . -mindepth 2 -type f | sort > stats_list.txt
find -L by_name -mindepth 2 -maxdepth 2 -type d | sort > stats_names.txt
wc -l stats_list.txt | cut -d ' ' -f 1 > stats_count.txt
du -sLh . > stats_du.txt
