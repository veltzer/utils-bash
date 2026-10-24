#!/bin/bash -eu

: <<'COMMENT'

This script updates all docker images

References:
- https://www.googlinux.com/update-all-docker-images/

COMMENT

if [ "$#" -ne 0 ]
then
	echo "$0: this script takes no arguments" >&2
	exit 1
fi

for x in $(docker images --format "{{.Repository}}")
do
	docker pull "${x}"
done
# docker images | grep -v REPOSITORY | awk '{print $1}' | xargs -L1 docker pull
