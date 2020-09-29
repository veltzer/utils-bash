#!/bin/bash

: <<'COMMENT'

This script removes all docker images. Use with care.

COMMENT

# read outpuf of command into an array
read -ra images < <(docker images --format "{{.ID}}")
# if the array has elements then remove them
if [ ${#images[@]} -gt 0 ]
then
	docker rmi "${images[@]}"
fi
