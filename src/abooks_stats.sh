#!/bin/bash

<<'COMMENT'

This script create the stats file which containts meta information about the collection

COMMENT

file=summary.txt

echo -n > $file
echo -n "number of authors: " >> $file
find . -mindepth 2 -maxdepth 2 -and -type d | wc -l >> $file
echo -n "number of works: " >> $file
find . -mindepth 3 -and -type d | wc -l >> $file
echo -n "number of files: " >> $file
find . -mindepth 4 -and -type f | wc -l >> $file
echo -n "size of collection: " >> $file
du -hs . | cut -f 1 >> $file
tree -L 2 by_name > list.txt
