#!/bin/bash

<<'COMMENT'

This is a script that allows you to move files with long names
without repeating the name of the file.

References:
- https://www.ostechnix.com/bash-tips-rename-files-without-typing-full-name-twice-in-linux/

COMMENT

if [ "$#" -ne 1 ]
then
	echo "$0: use with only one argument"
	exit 1
fi

read -ei "$1" newfilename
command mv -v -- "$1" "$newfilename"
