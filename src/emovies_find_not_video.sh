#!/bin/bash

# this checks that the files are of the right type
find by_name -mindepth 2 -and -type f -and -not -name "*.avi" -and -not -name "*.m4v" -and -not -name "*.mp4" -and -not -name "*.mkv" -and -not -name "*.wmv" -and -not -name "*.flv" -and -not -name "*.mov"
