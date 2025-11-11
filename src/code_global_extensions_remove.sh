#!/bin/bash -eu

# This script will remove all global extensions from vscode

EXTENSIONS="${HOME}/.vscode/extensions"
if [ -d "${EXTENSIONS}" ]
then
	echo "removing all extensions"
	rm -rf "${EXTENSIONS}"
fi
