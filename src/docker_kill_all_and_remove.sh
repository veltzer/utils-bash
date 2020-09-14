#!/bin/bash

<<'COMMENT'

This script kills all running docker containers and then removes
them.
Useful in tests and to "clean the table"...

References:
- https://towardsdatascience.com/15-docker-commands-you-should-know-970ea5203421

COMMENT

docker container kill $(docker ps -q)
docker container rm $(docker container ls -q)
