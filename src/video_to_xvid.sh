#!/bin/bash

<<'COMMENT'

This script converts videos given to it to the xvid codec, IN PLACE,
this means it replaces the original files...
this script changes the suffix of the file to avi.

COMMENT

SUFFIX=avi
OVC=xvid
OAC=mp3lame
# this prefix is used for various purposes but I mainly use it to make the encoding process
# nice because it takes lots of time...
PREFIX=nice

for x in "$@"; do
	echo "$x"
	y="$x.tmp"
	# this removes the suffix from the file name...
	name=${x%.*}.$SUFFIX
	$PREFIX mencoder "$x" -ovc $OVC -oac $OAC -xvidencopts fixed_quant=4 -o "$y"; ret=$?
	if [[ $ret -ne 0 ]]; then
		echo "problem converting file $x"
		echo "removing tmp file $y"
		rm -f "$y"
		break
	fi
	rm -f "$x"; ret=$?
	if [[ $ret -ne 0 ]]; then
		echo "problem removing original file $x"
		break
	fi
	mv -f "$y" "$name"; ret=$?
	if [[ $ret -ne 0 ]]; then
		echo "problem moving file $y to $name"
		break
	fi
	echo "file $x converted and replaced with $name successfuly..."
done
