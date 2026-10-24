#!/bin/bash -eu

if [ "$#" -ne 0 ]
then
	echo "$0: this script takes no arguments" >&2
	exit 1
fi

if [[ "${HOSTNAME}" = "fermat" ]]
then
	unison . "ssh://mark@abel:22/${PWD}"
fi
if [[ "${HOSTNAME}" = "abel" ]]
then
	unison . "ssh://mark@fermat:22/${PWD}"
fi
