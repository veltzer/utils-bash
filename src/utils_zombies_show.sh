#!/bin/bash

# This is a small script to show you all the zombie processes
# on the current machie
#ps aux | awk '{ print $8 " " $2 }' | grep -w Z
# TODO: rewrite this script in python and so be more accurate and flexible.
ps axo stat,pid,ppid,comm | grep -w defunct
