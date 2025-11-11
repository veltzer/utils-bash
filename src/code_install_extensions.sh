#!/bin/bash -eu

# This script will remove all vscode extensions and then will install the exact extensions
# listed in the local file ".vscode-extensions"

echo "removing all extensions"
rm -rf ~/.vscode/extensions
if [ -f ".vscode-extensions.txt" ]
then
	while read -r extension; do
	    code --force --install-extension "${extension}"
	done < ".vscode-extensions.txt"
else
	echo "you do not have a .vscode-extensions.txt file, stopping"
fi
