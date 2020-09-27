#!/bin/bash

<<'COMMENT'

This script removes all docker images which are "none" or "dangling". Use with care.

COMMENT

docker rmi $(docker images -f "dangling=true" -q)
# for x in `docker images --format "{{.ID}}"`
# do
# 	docker rmi "$x"
# done
