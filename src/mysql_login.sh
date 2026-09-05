#!/bin/bash -eu

# Log in to mysql(1) as the current user with the password kept in pass(1)
# under "passwords/mysql/${USER}". Every argument is passed on to mysql(1):
#
#	mysql_login.sh
#	mysql_login.sh -e 'show databases'
#	mysql_login.sh --defaults-group-suffix=myworld
#
# mysql(1) cannot ask pass(1) for a password itself, and a password= line in
# ~/.my.cnf beats both MYSQL_PWD and --defaults-extra-file. So we hand mysql a
# one-off option file: the usual config files in their usual order, followed
# by a [client] section whose password (being last) wins. The file is a pipe,
# so nothing lands on disk and nothing shows up in ps(1).

user="${USER}"
password=$(pass show "passwords/mysql/${user}")

options() {
	local f
	for f in /etc/my.cnf /etc/mysql/my.cnf "${HOME}/.my.cnf"; do
		if [ -r "${f}" ]; then
			cat "${f}"
		fi
	done
	printf '[client]\nuser=%s\npassword=%s\n' "${user}" "${password}"
}

exec mysql --defaults-file=<(options) "$@"
