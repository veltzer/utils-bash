#!/bin/bash -e

: <<'COMMENT'

This script updates all docker images

References:
- https://www.googlinux.com/update-all-docker-images/

COMMENT

for x in $(docker images --format "{{.Repository}}")
do
	docker pull "$x"
done
# docker images | grep -v REPOSITORY | awk '{print $1}' | xargs -L1 docker pull
