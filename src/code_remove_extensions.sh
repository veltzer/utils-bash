#!/bin/bash -eu

# This script will remove all non profile extensions from vscode

EXTENSIONS="${HOME}/.vscode/extensions"
if [ -f "${EXTENSIONS}" ]
then
	echo "removing all extensions"
	rm -rf "${EXTENSIONS}"
fi
