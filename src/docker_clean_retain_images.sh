#!/bin/bash -eu

: <<'COMMENT'

Clean both containers and images

COMMENT

for x in $(docker container ls --all -q)
do
	docker container rm "${x}"
done
for x in $(docker ps -q)
do
	docker kill "${x}"
done
for x in $(docker volume ls -q --filter dangling=true)
do
	docker volume rm "${x}"
done
docker network prune -f

#readarray -t images < <(docker images --format "{{.ID}}")
#if [ "${#images[@]}" -gt 0 ]
#then
#	docker rmi --force "${images[@]}"
#fi
