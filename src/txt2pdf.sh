#!/bin/bash -e

: <<'COMMENT'

This script converts a text file to pdf using the combination of
2 tools:
- enscript: converts between text and postscript
- ps2pdf: converts between postscript and pdf

References:
- https://unix.stackexchange.com/questions/17406/how-to-convert-txt-to-pdf

COMMENT

if [ $# -ne 2 ]
then
	echo "Usage: $0 [input.txt] [output.pdf]"
	exit 1
fi

tmpfile=$(mktemp /tmp/txt2pdf.sh.XXXXXX)
enscript "${1}" -p "${tmpfile}" 2> /dev/null
ps2pdf "${tmpfile}" "${2}"
rm "${tmpfile}"
