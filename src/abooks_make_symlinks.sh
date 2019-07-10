#!/bin/bash

<<'COMMENT'

This script will create symlinks so that you could access a piece by it's name only...

COMMENT

# remove all old links...
rm -f by_title_name/*
for x in by_name/*/* by_organization/*/*; do
	if [[ -d $x ]]; then
		y=`basename "$x"`
		ln -s "../$x" "by_title_name/$y"
	fi
done
