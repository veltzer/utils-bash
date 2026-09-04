#!/bin/bash -eu

# Stamp what is about to be deployed so the app can serve it back (e.g. via
# an app/version endpoint). The GAE version id is not known before the
# deploy; apps read it at runtime from the GAE_VERSION env var instead.
if git rev-parse --is-inside-work-tree > /dev/null 2>&1
then
	jq -n \
		--arg deploy_date "$(date --utc --iso-8601=seconds)" \
		--arg git_describe "$(git describe --always --dirty --tags)" \
		'{deploy_date: $deploy_date, git_describe: $git_describe}' > build_info.json
fi

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
