#!/bin/bash

for x in `echo "show tables" | mysql --skip-column-names`; do
	echo $x `echo "select count(*) from $x" | mysql --skip-column-names`
done
