#!/bin/bash -eu

: <<'COMMENT'

This script removes all docker containers, including stopped ones.
Use with care.

COMMENT

if [ "$#" -ne 0 ]
then
	echo "$0: this script takes no arguments" >&2
	exit 1
fi

for x in $(docker container ls --all -q)
do
	docker container rm "${x}"
done
