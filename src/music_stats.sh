#!/bin/bash

<<'COMMENT'

This script create the stats file which containts meta information about the collection

COMMENT

file=summary.stat
ALL_FOLDERS="by_name by_style"

echo -n > $file
echo -n "number of artists: " >> $file
find . -mindepth 2 -maxdepth 2 -and -type d | wc -l >> $file
echo -n "number of albums: " >> $file
find . -mindepth 3 -maxdepth 3 -and -type d | wc -l >> $file
echo -n "number of tracks: " >> $file
find . -mindepth 2 -and -type f | wc -l >> $file
echo -n "size of collection: " >> $file
du -hs . | cut -f 1 >> $file
# this is old code that counts files per file type.
# since there is just one file type now I don't need it
#for suff in mp3 ogg m4a wma flac; do
#	echo -n "number of $suff: " >> $file
#	find . -mindepth 2 -and -type f -and -name "*.$suff" | wc -l >> $file
#done
ls -lR > lslR.stat
find by_name -mindepth 1 -maxdepth 1 -type d > artists.stat
find $ALL_FOLDERS -mindepth 2 -maxdepth 2 -type d > albums.stat
find $ALL_FOLDERS -type f -and -name "*.mp3" > songs.stat
du -sh > du.stat
touch stamp.stat
