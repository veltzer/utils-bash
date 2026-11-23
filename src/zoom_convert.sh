#!/bin/bash -eu

if [[ "$#" -ne 0 ]]
then
	echo "$0: this script takes no arguments" >&2
	exit 1
fi

for x in */*
do
	dir=$(dirname "${x}")
	extension="${x##*.}"
	# echo "dir is ${dir}"
	new=$(sed -E -e 's/^([^ ]*)( [^ ]*)?.*/\1\2/' -e "s/-//g" -e "s/\.//g" -e "s/ /-/" <<< "${dir}")
	final="${new}.${extension}"
	mv "${x}" "${final}"
done
