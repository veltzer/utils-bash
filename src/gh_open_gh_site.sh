#!/bin/bash -eu

if [ "$#" -ne 0 ]
then
	echo "$0: this script takes no arguments" >&2
	exit 1
fi

url=$(gh api "repos/{owner}/{repo}/pages" --jq '.html_url')
xdg-open "${url}"
