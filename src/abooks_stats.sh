#!/bin/bash -e

: <<'COMMENT'

This script create the stats file which containts meta information about the collection

COMMENT

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
