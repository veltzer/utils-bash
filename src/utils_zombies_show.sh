#!/bin/bash

# This is a small script to show you all the zombie processes
# on the current machie
# Here are some other options for implementation:
#     ps aux | awk '{ print $8 " " $2 }' | grep -w Z
#     ps axo stat,pid,ppid,comm | grep -w defunct
#     read -ra pids < <(pgrep -r S)
#
# TODO: rewrite this script in python and so be more accurate and flexible.
#

ps -o stat,pid,ppid,comm -p "$(pgrep -r S -d ' ')"
