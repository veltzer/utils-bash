#!/bin/bash

<<'COMMENT'

this script copies a database in it's entirety. The idea is to allow you to play around
and not "fuck up" the real data.
TODO:
- turn this into a python script

COMMENT

# parameters
DB_SOURCE=myworld
DB_TARGET=copy_myworld

# here we go
echo "drop database if exists $DB_TARGET;" | mysql
echo "create database $DB_TARGET;" | mysql
mysqldump $DB_SOURCE | mysql $DB_TARGET
