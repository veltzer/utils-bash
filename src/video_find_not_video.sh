#!/bin/bash

<<'COMMENT'

This script finds all files under the current folder which are not video files.

COMMENT

find\
.\
-type -f\
-and -not -name "*.avi"\
-and -not -name "*.flv"\
-and -not -name "*.mp4"
