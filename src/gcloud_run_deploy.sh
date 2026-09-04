#!/bin/bash -eu

# Deploy the current repository to Cloud Run. This is the Cloud Run
# counterpart of gcloud_app_deploy.sh (App Engine): everything service-specific
# comes from the repository's .gcp.conf, so this script has no per-service
# knowledge and every Cloud Run repo deploys the same way.
#
# .gcp.conf is bash-sourced. Keys used here:
#   gcp_configuration_name  gcloud configuration to activate (required)
#   gcp_service             Cloud Run service name (required)
#   gcp_region              region to deploy to (required)
#   gcp_run_args            bash array of extra `gcloud run deploy` flags:
#                           service account, env vars, secrets, Cloud SQL,
#                           scaling, --[no-]allow-unauthenticated, ...
#
# Run from the repository root, where .gcp.conf lives. Cloud Build builds
# the Dockerfile and the new revision replaces the old one; Cloud Run keeps
# revision history itself, so unlike App Engine there is nothing to clean up.

if [[ ! -r .gcp.conf ]]
then
	echo "${0}: no .gcp.conf in $(pwd); run from the repository root" >&2
	exit 1
fi

gcp_run_args=()
# shellcheck source=/dev/null
source .gcp.conf
: "${gcp_configuration_name:?must be set in .gcp.conf}"
: "${gcp_service:?must be set in .gcp.conf}"
: "${gcp_region:?must be set in .gcp.conf}"
export CLOUDSDK_ACTIVE_CONFIG_NAME="${gcp_configuration_name}"

# Stamp what is about to be deployed so the app can serve it back (e.g. via
# an app/version endpoint). The Cloud Run revision name is not known before
# the deploy; apps read it at runtime from the K_REVISION env var instead.
jq -n \
	--arg deploy_date "$(date --utc --iso-8601=seconds)" \
	--arg git_describe "$(git describe --always --dirty --tags)" \
	'{deploy_date: $deploy_date, git_describe: $git_describe}' > build_info.json

exec gcloud run deploy "${gcp_service}" \
	--source . \
	--region "${gcp_region}" \
	--quiet \
	"${gcp_run_args[@]}"
