#!/bin/bash

find . -mindepth 2 -type f -and -not -perm 444 -exec chmod 444 "{}" \;
find . -mindepth 2 -type d -and -not -perm 775 -exec chmod 775 "{}" \;
