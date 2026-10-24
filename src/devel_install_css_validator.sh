#!/bin/bash -eu

: <<'COMMENT'

This script installs the tip of the css-validator project

COMMENT

if [ "$#" -ne 0 ]
then
	echo "$0: this script takes no arguments" >&2
	exit 1
fi

git clone --depth 1 --branch master git@github.com:w3c/css-validator.git
cd css-validator || exit
ant
