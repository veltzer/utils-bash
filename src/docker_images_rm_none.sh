#!/bin/bash -eu

: <<'COMMENT'

This script removes all docker images which are "none" or "dangling". Use with care.

COMMENT

if [[ "$#" -ne 0 ]]
then
	echo "$0: this script takes no arguments" >&2
	exit 1
fi

image_ids=$(docker images -f "dangling=true" -q)
if [[ -n "${image_ids}" ]]
then
	readarray -t images <<< "${image_ids}"
	docker rmi "${images[@]}"
fi
