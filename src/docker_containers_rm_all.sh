#!/bin/bash -eu

: <<'COMMENT'

This script removes all docker containers, including stopped ones.
Use with care.

COMMENT

for x in $(docker container ls --all -q)
do
	docker container rm "${x}"
done
