#!/bin/bash

: <<'COMMENT'

This script removes all docker images which are "none" or "dangling". Use with care.

COMMENT

# read outpuf of command into an array
read -ra images < <(docker images -f "dangling=true" -q)
# if the array has elements then remove them
if [ ${#images[@]} -gt 0 ]
then
	docker rmi "${images[@]}"
fi
# for x in `docker images --format "{{.ID}}"`
# do
# 	docker rmi "$x"
# done
