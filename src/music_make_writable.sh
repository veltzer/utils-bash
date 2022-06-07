#!/bin/bash -e

find . -mindepth 2 -type f -exec chmod 644 "{}" \;
