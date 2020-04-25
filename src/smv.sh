#!/bin/bash

<<'COMMENT'

This is a script that allows you to move files with long names
without repeating the name of the file.

References:
- https://www.ostechnix.com/bash-tips-rename-files-without-typing-full-name-twice-in-linux/

COMMENT

if [ "$#" -ne 1 ] || [ ! -e "$1" ]
then
	command mv "$@"
	return
fi

read -ei "$1" newfilename
command mv -v -- "$1" "$newfilename"
