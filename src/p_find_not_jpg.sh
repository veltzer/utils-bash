#!/bin/bash
# find regular files without .jpg extension
find -L . -mindepth 2 -type f -and -not -name "*.jpg" > err_jpg.txt
