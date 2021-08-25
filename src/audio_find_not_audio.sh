#!/bin/bash -e

: <<'COMMENT'

This script finds all files under the current folder which are not audio files.

COMMENT

find . \
-mindepth 2 \
-type f \
-and -not -name "*.mp3" \
-and -not -name "*.m3u"
