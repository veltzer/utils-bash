#!/bin/bash -eu

# This script will remove all global extensions from vscode

if [ "$#" -ne 0 ]
then
	echo "$0: this script takes no arguments" >&2
	exit 1
fi

EXTENSIONS="${HOME}/.vscode/extensions"
if [ -d "${EXTENSIONS}" ]
then
	echo "removing all extensions"
	rm -rf "${EXTENSIONS}"
fi
