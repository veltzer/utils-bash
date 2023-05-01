#!/bin/bash -e

if [[ $# -ne 2 ]]
then
	echo "usage: $0 [from] [to]"
	exit 1
fi

from=$1
to=$2
(cd "${from}" && git archive --format=tar HEAD) | (cd "${to}" && tar xf -)
