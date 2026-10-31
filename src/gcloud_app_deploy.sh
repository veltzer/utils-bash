#!/bin/bash -eu

if [ "$#" -ne 0 ]
then
	echo "$0: this script takes no arguments" >&2
	exit 1
fi

# Only committed code is deployed: gcloud uploads the working tree, not a git
# revision, so a dirty tree would put code on the live site that is in no
# commit and cannot be reproduced or rolled back to. Untracked files count
# too (they are uploaded unless ignored); ignored ones, such as the
# build_info.json written below, do not.
if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1
then
	echo "${0}: $(pwd) is not a git repository; only committed code is deployed" >&2
	exit 1
fi
if [[ -n "$(git status --porcelain)" ]]
then
	echo "${0}: the working tree has uncommitted changes; commit them first:" >&2
	git status --short >&2
	exit 1
fi

# Stamp what is about to be deployed so the app can serve it back (e.g. via
# an app/version endpoint). The GAE version id is not known before the
# deploy; apps read it at runtime from the GAE_VERSION env var instead.
jq -n \
	--arg deploy_date "$(date --utc --iso-8601=seconds)" \
	--arg git_describe "$(git describe --always --dirty --tags)" \
	'{deploy_date: $deploy_date, git_describe: $git_describe}' > build_info.json

# Deploy the new version first
gcloud app deploy --promote --stop-previous-version --quiet

# Get a list of all versions and their traffic splits
versions=$(gcloud app versions list --format=json)

# Extract the IDs of versions with 0 traffic split
inactive_versions=$(echo "${versions}" | jq -r ".[] | select(.traffic_split==0.0) | .id")

# If there are any inactive versions, delete them
if [[ -n "${inactive_versions}" ]]
then
	# Iterate over each inactive version and delete it
	while IFS= read -r version
	do
		echo "Deleting inactive version: ${version}"
		gcloud app versions delete "${version}" --quiet
	done <<< "${inactive_versions}"
else
	echo "No inactive versions found."
fi
