#!/bin/bash -eu

# This code will list the current extensions installed to your vscode on the terminal

if [ "$#" -ne 0 ]
then
	echo "$0: this script takes no arguments" >&2
	exit 1
fi

code --list-extensions
