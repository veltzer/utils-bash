#!/bin/bash -e

find . -mindepth 2 -type f -and -not -perm 444 -exec chmod 444 "{}" \;
