#!/bin/bash

<<'COMMENT'

This script creates a playlist from the current folder

COMMENT

find . \
-type f \
-and \
\( \
-name "*.avi" \
-or -name "*.flv" \
-or -name "*.wmv" \
-or -name "*.mpg" \
-or -name "*.asf" \
-or -name "*.mpeg" \
-or -name "*.rm" \
-or -name "*.mov" \
-or -name "*.mkv" \
-or -name "*.3gp" \
-or -name "*.ram" \
-or -name "*.m4v" \
-or -name "*.rmvb" \
-or -name "*.qt" \
-or -name "*.mp4" \
-or -name "*.VOB" \
\) > playlist.m3u
