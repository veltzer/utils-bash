#!/bin/bash

: <<'COMMENT'

This script removes all docker images. Use with care.

COMMENT

for x in `docker images --format "{{.ID}}"`
do
	docker rmi "$x"
done
