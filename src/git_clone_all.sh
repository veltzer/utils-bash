#!/bin/bash -eu

for x in /home/mark/git/repos/*.git
do
	echo "${x}"
	git clone "${x}"
done
