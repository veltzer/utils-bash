#!/bin/bash -eu

: <<'COMMENT'

This is a simple bash script which just prints the number of arguments it gets.
It is useful when you need to using globbing and count how many files you globbed.

COMMENT

echo "Number of arguments: $#"
