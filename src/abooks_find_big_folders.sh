#!/bin/bash

<<'COMMENT'

This script will find folders with large amount of files in them...

COMMENT

find by_name -type d -exec sh -c 'set -- "$0"/*.mp3; [ $# -ge 100 ]' {} \; -print
