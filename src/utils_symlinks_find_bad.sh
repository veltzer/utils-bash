#!/bin/bash

: <<'COMMENT'

This is a small script to find bad symbolic links and printout their
names.
TODO: rewrite this script in python to be more extendable and possibly
a lot faster.

COMMENT

#find . -type l -and -not -exec test -e {} \; -print
# it seems that firefox always creates a lock dangling symlink which
# I have no great desire to see.
find .\
	-type l\
	-and -not -exec test -e {} \;\
	-and -not -ipath "*/firefox/*"\
	-and -not -ipath "*/google-chrome/*"\
	-and -not -ipath "*/spyder.lock"\
	-and -not -ipath "*/whatsdesk/*"\
	-print
