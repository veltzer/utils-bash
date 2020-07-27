#!/bin/bash

<<'COMMENT'

This script removes all docker containers, including stopped ones.
Use with care.

COMMENT

for x in `docker container ls --all --format "{{.ID}}"`
do
	docker container rm "$x"
done
