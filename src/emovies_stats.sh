#!/bin/bash

<<'COMMENT'

This script create the stats file which containts meta information about the collection

COMMENT

file=summary.txt

echo -n > $file
echo -n "number of authors: " >> $file
find by_name -mindepth 1 -maxdepth 1 -and -type d | wc -l >> $file
echo -n "number of works: " >> $file
find by_name -mindepth 2 -maxdepth 2 -and -type d | wc -l >> $file
echo -n "number of files: " >> $file
find by_name -mindepth 3 -maxdepth 3 -and -type f | wc -l >> $file
echo -n "size of collection: " >> $file
du -hs . | cut -f 1 >> $file
tree -L 2 by_name > list.txt
