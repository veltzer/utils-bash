#!/bin/bash -eu

if [ "$#" -ne 0 ]
then
	echo "$0: this script takes no arguments" >&2
	exit 1
fi

# this is a version without profile support
#
echo "removing all extensions"
rm -rf "${HOME}/.vscode/extensions"
if [ -f ".vscode-extensions.txt" ]
then
	while read -r extension
	do
		code --force --install-extension "${extension}"
	done < ".vscode-extensions.txt"
else
	echo "you do not have a .vscode-extensions.txt file, stopping"
fi
