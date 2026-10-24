#!/bin/bash -eu

# if [ $# -ne 1 ]; then
# 	echo "Error: This script requires a version"
# 	echo "You can get it from: gcloud app versions list"
# 	echo "Usage: $0 [version]"
# 	exit 1
# fi
# version="$1"

if [ "$#" -ne 0 ]
then
	echo "$0: this script takes no arguments" >&2
	exit 1
fi

# get the latest version deployed
version=$(gcloud app versions list --format=json | jq -r ".[0].id")

service="default"
gcloud app versions describe "${version}" --service "${service}" --format=json | jq -r ".deployment.files | keys[]"
