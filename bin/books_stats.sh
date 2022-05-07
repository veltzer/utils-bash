#!/bin/bash -e

: <<'COMMENT'

This script create the stats file which containts meta information about the collection

COMMENT

file=summary.txt

# the list of suffixes we support for book content
suffs=(chm tar.bz2 pdf ps html dvi lit doc djvu zip rtf txt pdb mht rar jpg js gif)

{
	echo -n > $file
	echo -n "number of authors: "
	find . -mindepth 2 -maxdepth 2 -and -type d | wc -l
	echo -n "number of works: "
	find . -mindepth 2 -and -type f | wc -l
	echo -n "size of collection: "
	du -hs . | cut -f 1
} > $file
# this is old code that counts files per file type.
# since there is just one file type now I don't need it
((sum=0))
for suff in "${suffs[@]}"
do
	echo -n "number of $suff: "
	num=$(find . -mindepth 2 -and -type f -and -name "*.$suff" | wc -l)
	echo "$num"
	((sum+=num))
done
echo "sum of all types is $sum"
