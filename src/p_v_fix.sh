#!/bin/bash
find . -mindepth 2 -type f -perm +222 -exec chmod 444 '{}' \;
find . -mindepth 2 -type d -exec chmod 755 '{}' \;
