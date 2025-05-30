#!/bin/bash -eu

# This is a small script to show you all the zombie processes
# on the current machie
# Here are some other options for implementation:
#     ps aux | awk '{ print $8 " " $2 }' | grep -w Z
#     ps axo stat,pid,ppid,comm | grep -w defunct
#     readarray -t pids < <(pgrep --runstates Z)
#
# TODO: rewrite this script in python and so be more accurate and flexible.
#

readarray -t pids < <(pgrep --runstates Z)
if test "${#pids[@]}" -gt 0
then
	ps -o stat,pid,ppid,comm -p "${pids[@]}"
fi
