#!/bin/bash -eu

# Map the custom domain of the current repository to its Cloud Run service
# and print the DNS records to create at the registrar. Safe to re-run: the
# mapping is created only if missing and the records and certificate status
# are always printed, so this doubles as the way to check on the certificate
# later.
#
# .gcp.conf is bash-sourced. Keys used here:
#   gcp_configuration_name  gcloud configuration to activate (required)
#   gcp_service             Cloud Run service name (required)
#   gcp_region              region of the service (required)
#   gcp_domain              the domain to map, e.g. example.com (required)
#
# Prerequisites, both one-time and by hand:
#   - the service is deployed (gcloud_run_deploy.sh)
#   - the domain is verified for your Google account (`gcloud domains verify`)
#
# The registrar records must be plain DNS (at Cloudflare: proxy off), since
# Cloud Run issues and renews the certificate itself and has to see the
# origin directly.

if [[ ! -r .gcp.conf ]]
then
	echo "${0}: no .gcp.conf in $(pwd); run from the repository root" >&2
	exit 1
fi
# shellcheck source=/dev/null
source .gcp.conf
: "${gcp_configuration_name:?must be set in .gcp.conf}"
: "${gcp_service:?must be set in .gcp.conf}"
: "${gcp_region:?must be set in .gcp.conf}"
: "${gcp_domain:?must be set in .gcp.conf}"
export CLOUDSDK_ACTIVE_CONFIG_NAME="${gcp_configuration_name}"

echo "== domain mapping ${gcp_domain} -> ${gcp_service} (${gcp_region})"
if ! gcloud beta run domain-mappings describe --domain "${gcp_domain}" --region "${gcp_region}" > /dev/null 2>&1
then
	gcloud beta run domain-mappings create --service "${gcp_service}" --domain "${gcp_domain}" --region "${gcp_region}"
fi

echo "== DNS records to create at the registrar for ${gcp_domain} (plain DNS, no proxy)"
gcloud beta run domain-mappings describe --domain "${gcp_domain}" --region "${gcp_region}" \
	--flatten status.resourceRecords \
	--format 'table[no-heading](status.resourceRecords.type, status.resourceRecords.rrdata)'

echo "== status (the certificate is issued once the records resolve; can take up to an hour)"
gcloud beta run domain-mappings describe --domain "${gcp_domain}" --region "${gcp_region}" \
	--flatten status.conditions \
	--format 'table(status.conditions.type, status.conditions.status, status.conditions.message)'
