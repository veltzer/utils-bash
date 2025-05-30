#!/bin/bash -eu

for file in "$@"
do
	aspell --conf-dir=. --conf=.aspell.conf check "${file}"
done
