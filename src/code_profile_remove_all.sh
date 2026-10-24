#!/bin/bash -eu

# This script removes all profiles from vscode

if [ "$#" -ne 0 ]
then
	echo "$0: this script takes no arguments" >&2
	exit 1
fi

PROFILES_FOLDER="${HOME}/.config/Code/User/profiles"

if [ -d "${PROFILES_FOLDER}" ]
then
	echo "the profiles folder [${PROFILES_FOLDER}] exists. removing it."
	rm -rf "${PROFILES_FOLDER}"
else
	echo "the profiles folder [${PROFILES_FOLDER}] doesnt exist. Nothing to do."
fi
