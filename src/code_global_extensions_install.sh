#!/bin/bash -eu

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
