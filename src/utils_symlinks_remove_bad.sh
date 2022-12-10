#!/bin/bash -e

# this is a small script to find bad symbolic links and printout their
# names.
# TODO: rewrite this script in python to be more extendble and possible
# a lot faster.
# the -print is to print every removed symlink, remove the flag if you
# like this script to be more quiet.
find . -type l -and -not -exec test -e {} \; -delete -print
