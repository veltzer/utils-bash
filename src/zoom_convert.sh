#!/bin/bash -e

for x in */*
do
	dir=$(dirname "${x}")
	extension="${x##*.}"
	# echo "dir is ${dir}"
	new=$(echo "${dir}" | cut -d " " -f1,2 | sed "s/-//g" | sed "s/\.//g" | sed s"/ /-/")
	final="${new}.${extension}"
	mv "${x}" "${final}"
done
