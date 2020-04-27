#!/bin/bash

<<'COMMENT'

This is a script that allows you to move files with long names
without repeating the name of the file.

References:
- https://www.ostechnix.com/bash-tips-rename-files-without-typing-full-name-twice-in-linux/

COMMENT

if [ "$#" -eq 0 ]
then
	echo "$0: use with at least one argument"
	exit 1
fi

for var in "$@"
do
	read -ei "$var" newfilename
	command mv -v -- "$var" "$newfilename"
done

