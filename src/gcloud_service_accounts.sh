#!/bin/bash -eu

# List the service accounts of the current project, with whether each is
# disabled. Reads .gcp.conf for the gcloud configuration when run from a
# repository root; otherwise the active configuration is used.

if [[ -r .gcp.conf ]]
then
	# shellcheck source=/dev/null
	source .gcp.conf
	export CLOUDSDK_ACTIVE_CONFIG_NAME="${gcp_configuration_name:?must be set in .gcp.conf}"
fi

echo "project $(gcloud config get-value project 2> /dev/null)"
gcloud iam service-accounts list --format 'table(email, disabled, displayName)'
