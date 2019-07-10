#!/bin/bash

<<'COMMENT'

This script receives a list of mp3s to play, plays them and records each one to a specific list file.

COMMENT

FILE="/mnt/sdd1/mark/dev/personal/music/listening/heard.list"

echo "do not use this script - use the new one (with the .pl extension)...\n"
exit

if [[ ! -f $FILE ]]; then
	echo "File is not there. Refusing to start"
	exit
fi

for x in "$@"; do
	# lets play the song
	# mplayer was chosen over mpg123 or mpg321 cause he gives an error if stopped
	# with ctrl+c.
	mplayer "$x"
	# record the result
	ret=$?
	if [[ $ret -eq 0 ]]; then
		# record the file name
		echo `realpath "$x"` >> $FILE
		# record the id3 tags
		id3 -l "$x" >> $FILE
		# record the date
		date >> $FILE
		# separator
		echo "=======================" >> $FILE
	else
		echo "problem playing song $x"
		break
	fi
done
