#!/bin/bash -eu

if [ "$#" -ne 0 ]
then
	echo "$0: this script takes no arguments" >&2
	exit 1
fi

project=$(python -m "import config.project; print(config.project.name)")
# Open a browswer on the remote sight stuff
xdg-open "https://veltzer.github.io/${project}"
