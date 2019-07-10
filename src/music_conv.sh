#!/bin/bash

<<'COMMENT'

This script converts wma files to ogg vorbis files
use with care

COMMENT

if [ $# -eq 0 ]
then
	echo "Usage: `basename $0` FILE [FILE]..."
	exit 1
fi

for source in "$@"; do
	if [ -f "$source" ]; then
		echo "Encoding $source"
		base=${source%.*} # remove suffix
		dest="$base.ogg"

		tmp=tmp.wav
		if [ -e $tmp ]; then
			rm -f $tmp
		fi
		mkfifo $tmp

		#Rip with Mplayer / encode with oggenc
		mplayer -quiet -vo null -vc null -ao pcm:waveheader:file=$tmp "$source" &>/dev/null \
		& oggenc -o "$dest" $tmp;
		stat=$?
		rm -f $tmp

		if [ $stat -ne 0 ]; then
			echo "Error $stat"
		fi
	fi
done
