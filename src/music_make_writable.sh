#!/bin/bash -eu

find . -mindepth 2 -type f -exec chmod 644 "{}" \;
