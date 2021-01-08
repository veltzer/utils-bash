#!/bin/bash

: <<'COMMENT'

This script removes all docker images which are "none" or "dangling". Use with care.

COMMENT

readarray -t images < <(docker images -f "dangling=true" -q)
if [ "${#images[@]}" -gt 0 ]
then
	docker rmi "${images[@]}"
fi
