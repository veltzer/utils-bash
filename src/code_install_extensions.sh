#!/bin/bash -eu

# This script will remove all vscode extensions and then will install the exact extensions
# listed in the local file ".vscode-extensions"

PROFILE_NAME=$(basename "${PWD}")
PROFILE="${HOME}/.config/Code/User/profiles/${PROFILE_NAME}"
EXTENSIONS_FILE=".vscode-extensions.txt"

if [ -f "${PROFILE}" ]
then
	echo "the profile [${PROFILE}] exists. removing it."
	rm -rf "${PROFILE}"
else
	echo "the profile [${PROFILE}] does not exist. Nothing to do."
fi

echo "Creating profile [${PROFILE_NAME}] by opening VS Code..."
# Create the profile by opening the current directory
# (it will open and close quickly)
code . --profile "${PROFILE_NAME}" --wait

echo "Installing extensions into [${PROFILE_NAME}]..."

# Read each line from extensions.txt and install
while read -r extension
do
	if [ -n "${extension}" ]
	then
		echo "Installing [${extension}]..."
		code --install-extension "${extension}" --profile "${PROFILE_NAME}"
	fi
done < "${EXTENSIONS_FILE}"


# this is a version without profile support
# echo "removing all extensions"
# rm -rf ~/.vscode/extensions
# if [ -f ".vscode-extensions.txt" ]
# then
# 	while read -r extension
#	do
# 	    code --force --install-extension "${extension}"
# 	done < ".vscode-extensions.txt"
# else
# 	echo "you do not have a .vscode-extensions.txt file, stopping"
# fi
