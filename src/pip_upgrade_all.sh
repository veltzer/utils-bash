#!/bin/bash -eu

if [[ "$#" -ne 0 ]]
then
	echo "$0: this script takes no arguments" >&2
	exit 1
fi

# This will upgrade all the pip modules that can be upgraded
outdated=$(pip list --outdated --format=columns)
status=0
while read -r name _
do
	if [[ -n "${name}" ]]
	then
		pip install --upgrade "${name}" || status=123
	fi
done <<< "${outdated}"
exit "${status}"
