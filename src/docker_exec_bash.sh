#!/bin/bash -eu

: <<'COMMENT'

Connect with a shell to a running docker container

COMMENT

if [ "$#" -ne 0 ]
then
	echo "$0: this script takes no arguments" >&2
	exit 1
fi

id=$(docker ps --latest --format "{{.ID}}")
docker exec -it "${id}" bash
