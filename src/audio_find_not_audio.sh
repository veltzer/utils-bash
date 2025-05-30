#!/bin/bash -eu

: <<'COMMENT'

This script finds all files under the current folder which are not audio files.

COMMENT

find . \
-mindepth 2 \
-type f \
-and \( \
-not -name "*.mp3" \
-and -not -name "*.m3u" \
-and -not -name "*.m4b" \
-and -not -name "*.ogg" \
-and -not -name "*.m4a" \)
