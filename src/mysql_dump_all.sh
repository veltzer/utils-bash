#!/bin/bash

<<'COMMENT'

This script dumps all databases

References:
http://stackoverflow.com/questions/9497869/export-and-import-all-mysql-databases-at-one-time

TODO:
- rewrite this in python

COMMENT

source ~/.myworld.sh

databases=`mysql -u $USER -p$PASS -e "SHOW DATABASES;" | tr -d "| " | grep -v Database`

for db in $databases; do
	if [[ "$db" != "information_schema" ]] && [[ "$db" != "performance_schema" ]] && [[ "$db" != "mysql" ]] && [[ "$db" != _* ]] ; then
		echo "Dumping database: $db"
		mysqldump -u $USER -p$PASS --databases $db > `date +%Y%m%d`.$db.sql
	fi
done
