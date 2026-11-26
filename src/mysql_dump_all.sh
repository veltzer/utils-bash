#!/bin/bash -eu

: <<'COMMENT'

This script dumps all databases

References:
http://stackoverflow.com/questions/9497869/export-and-import-all-mysql-databases-at-one-time

TODO:
- rewrite this in python

COMMENT

if [[ "$#" -ne 0 ]]
then
	echo "$0: this script takes no arguments" >&2
	exit 1
fi

# shellcheck source=/dev/null
source ~/.myworld.sh

database_table=$(mysql -u "${USER}" -e "SHOW DATABASES;")
database_table=${database_table//[| ]/}
databases=$(grep -v Database <<< "${database_table}")

for db in ${databases}
do
	if [[ "${db}" != "information_schema" ]] && [[ "${db}" != "performance_schema" ]] && [[ "${db}" != "mysql" ]] && [[ "${db}" != _* ]]
	then
		echo "Dumping database: ${db}"
		mysqldump -u "${USER}" --databases "${db}" > "$(date +%Y%m%d).${db}.sql"
	fi
done
