#!/bin/bash -e

: <<'COMMENT'

This script removes all docker images. Use with care.

COMMENT

readarray -t images < <(docker images --format "{{.ID}}")
if [ "${#images[@]}" -gt 0 ]
then
	docker rmi --force "${images[@]}"
fi
