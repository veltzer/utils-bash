#!/bin/bash -eu

if [ "$#" -ne 0 ]
then
	echo "$0: this script takes no arguments" >&2
	exit 1
fi

for x in $(echo "show tables" | mysql --skip-column-names)
do
	echo "${x}" "$(echo "select count(*) from ${x}" | mysql --skip-column-names)"
done
