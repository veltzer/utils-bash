#!/bin/bash

<<'COMMENT'

This script kills all running docker containers

References:
- https://towardsdatascience.com/15-docker-commands-you-should-know-970ea5203421

COMMENT

docker container kill $(docker ps -q)
