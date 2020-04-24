#!/bin/bash

<<'COMMENT'

This script finds all files under the current folder which are not video files.

COMMENT

find . \
-type f \
-and -not -name "*.avi" \
-and -not -name "*.flv" \
-and -not -name "*.wmv" \
-and -not -name "*.mpg" \
-and -not -name "*.asf" \
-and -not -name "*.mpeg" \
-and -not -name "*.rm" \
-and -not -name "*.mov" \
-and -not -name "*.mkv" \
-and -not -name "*.3gp" \
-and -not -name "*.ram" \
-and -not -name "*.m4v" \
-and -not -name "*.rmvb" \
-and -not -name "*.qt" \
-and -not -name "*.mp4" \
-and -not -name "*.VOB" \
-and -not -name "*.m3u"
