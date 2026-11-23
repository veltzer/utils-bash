#!/bin/bash -eu

if [[ "$#" -ne 0 ]]
then
	echo "$0: this script takes no arguments" >&2
	exit 1
fi

installer=$(curl https://sdk.cloud.google.com)
bash <<< "${installer}"
gcloud auth login
gcloud components update
