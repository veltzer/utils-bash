#!/bin/bash -eu

: <<'COMMENT'

This script kills all running docker containers and then removes
them.
Useful in tests and to "clean the table"...

References:
- https://towardsdatascience.com/15-docker-commands-you-should-know-970ea5203421

COMMENT

for x in $(docker ps -q)
do
	docker kill "${x}"
done
for x in $(docker container ls --all -q)
do
	docker container rm "${x}"
done
