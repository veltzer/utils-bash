#!/bin/bash
find -L . -mindepth 4 -type f -not -perm 444 -exec chmod 444 '{}' \+
find -L . -maxdepth 3 -type d -not -perm 755 -exec chmod 755 '{}' \+
