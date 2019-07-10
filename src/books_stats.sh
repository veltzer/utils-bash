#!/bin/bash

<<'COMMENT'

This script create the stats file which containts meta information about the collection

COMMENT

file=summary.txt

# the list of suffixes we support for book content
suffs=(chm tar.bz2 pdf ps html dvi lit doc djvu zip rtf txt pdb mht rar jpg js gif)

echo -n > $file
echo -n "number of authors: " >> $file
find . -mindepth 2 -maxdepth 2 -and -type d | wc -l >> $file
echo -n "number of works: " >> $file
find . -mindepth 2 -and -type f | wc -l >> $file
echo -n "size of collection: " >> $file
du -hs . | cut -f 1 >> $file
# this is old code that counts files per file type.
# since there is just one file type now I don't need it
let "sum=0"
for suff in ${suffs[*]}; do
	echo -n "number of $suff: " >> $file
	num=$(find . -mindepth 2 -and -type f -and -name "*.$suff" | wc -l)
	echo $num >> $file
	let "sum+=num"
done
echo "sum of all types is $sum" >> $file
