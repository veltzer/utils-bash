#!/bin/bash -eu

# This script will dump all current extensions install to your vscode to a local file
# called ".vscode-extensions.txt"

if [ "$#" -ne 0 ]
then
	echo "$0: this script takes no arguments" >&2
	exit 1
fi

code --list-extensions > ".vscode-extensions.txt"
