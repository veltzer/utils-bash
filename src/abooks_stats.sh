#!/bin/bash -eu

: <<'COMMENT'

This script create the stats file which containts meta information about the collection

COMMENT

if [ "$#" -ne 0 ]
then
	echo "$0: this script takes no arguments" >&2
	exit 1
fi

file=summary.txt

{
echo -n
echo -n "number of authors: "
find . -mindepth 2 -maxdepth 2 -and -type d | wc -l
echo -n "number of works: "
find . -mindepth 3 -and -type d | wc -l
echo -n "number of files: "
find . -mindepth 4 -and -type f | wc -l
echo -n "size of collection: "
du -hs . | cut -f 1
} > "${file}"
tree -L 2 by_name > list.txt
