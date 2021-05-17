#!/bin/bash
for x in */Makefile
do
	echo "$x"
	grep make_helper "$x"
done
