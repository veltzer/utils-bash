#!/bin/bash -eu

if [[ $# -eq 2 ]]; then
	cp "$2" "$1"
else
	pdfunite ./*.pdf "$1"
fi
