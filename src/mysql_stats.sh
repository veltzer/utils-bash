#!/bin/bash -eu

if [[ "$#" -ne 0 ]]
then
	echo "$0: this script takes no arguments" >&2
	exit 1
fi

for x in $(echo "show tables" | mysql --skip-column-names)
do
	row_count=$(mysql --skip-column-names <<< "select count(*) from ${x}")
	echo "${x}" "${row_count}"
done
