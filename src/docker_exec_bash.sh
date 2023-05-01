#!/bin/bash -e

: <<'COMMENT'

Connect with a shell to a running docker container

COMMENT

id=$(docker ps --latest --format "{{.ID}}")
docker exec -it "${id}" bash
