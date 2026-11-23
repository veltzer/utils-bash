#!/bin/bash -eu

if [[ $# -ne 2 ]]
then
	echo "usage: $0 [from] [to]"
	exit 1
fi

from=$1
to=$2
archive=$(mktemp)
trap 'rm -f "${archive}"' EXIT
git -C "${from}" archive --format=tar HEAD > "${archive}"
tar -C "${to}" -xf "${archive}"
