#!/bin/bash

<<'COMMENT'

This script alters the character set of a tables in a database

TODO:
- rewrite this script as a python script

COMMENT

source ~/.myworld.sh

# parameters...
CHARSET='utf8'
COLLATION='utf8_unicode_ci'

# here we go...
QUERY="SELECT table_name FROM information_schema.TABLES WHERE table_schema = '$DB';"
TABLES=$(mysql -u $USER --password=$PASS $DB --batch --skip-column-names --execute="$QUERY")
for TABLE in $TABLES; do
	echo "ALTER TABLE $TABLE ......"
	mysql -u $USER --password=$PASS $DB -e "ALTER TABLE $TABLE CONVERT TO CHARSET $CHARSET"
	#mysql -u $USER --password=$PASS $DB -e "ALTER TABLE $TABLE CONVERT TO CHARSET $CHARSET COLLATE $COLLATION"
done
