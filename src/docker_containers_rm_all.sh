#!/bin/bash

<<'COMMENT'

This script removes all docker containers, including stopped ones.
Use with care.

COMMENT

docker container rm $(docker container ls -q)
