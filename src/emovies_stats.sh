#!/bin/bash -e

: <<'COMMENT'

This script create the stats file which containts meta information about the collection

COMMENT

if [ ! -d by_name ]
then
	echo "Put me in the right folder"
	exit 1
fi

file=stats.txt

{
echo -n
echo -n "number of authors: "
find by_name -mindepth 1 -maxdepth 1 -and -type d | wc -l
echo -n "number of works: "
find by_name -mindepth 2 -maxdepth 2 -and -type d | wc -l
echo -n "number of files: "
find by_name -mindepth 3 -maxdepth 3 -and -type f | wc -l
echo -n "size of collection: "
du -hs . | cut -f 1
} > "${file}"
tree -L 2 by_name > list.txt
