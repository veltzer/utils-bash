#!/bin/bash -eu

aspell --conf-dir=. --conf=.aspell.conf check "$1"
