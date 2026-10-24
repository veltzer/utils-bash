#!/bin/bash -eu

: <<'COMMENT'

Clean both containers and images

COMMENT

if [ "$#" -ne 0 ]
then
	echo "$0: this script takes no arguments" >&2
	exit 1
fi

docker_containers_kill_all_rm_all.sh
docker_containers_kill_all.sh
docker_images_rm_all.sh
for x in $(docker volume ls -q --filter dangling=true)
do
	docker volume rm "${x}"
done
docker network prune -f
