#!/bin/bash -e

: <<'COMMENT'

Clean both containers and images

COMMENT

docker_containers_kill_all_rm_all.sh
docker_containers_kill_all.sh
docker_images_rm_all.sh
