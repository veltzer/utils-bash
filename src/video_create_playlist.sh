#!/bin/bash

<<'COMMENT'

This script creates a playlist from the current folder

COMMENT

find . \
-type f \
-and \
\( \
-iname "*.avi" \
-or -iname "*.flv" \
-or -iname "*.wmv" \
-or -iname "*.mpg" \
-or -iname "*.asf" \
-or -iname "*.mpeg" \
-or -iname "*.rm" \
-or -iname "*.mov" \
-or -iname "*.mkv" \
-or -iname "*.3gp" \
-or -iname "*.ram" \
-or -iname "*.m4v" \
-or -iname "*.rmvb" \
-or -iname "*.qt" \
-or -iname "*.mp4" \
-or -iname "*.VOB" \
-or -iname "*.vid" \
\) > playlist.m3u
