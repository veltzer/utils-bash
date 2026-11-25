#!/bin/bash -eu

# One-time project setup for a Cloud Run repository, driven entirely by its
# .gcp.conf: enable APIs, create the service account the app runs as and
# grant its roles, create the Cloud SQL instance, and put secrets in Secret
# Manager. Safe to re-run: every step skips what already exists. Deploying
# afterwards is gcloud_deploy.sh.
#
# .gcp.conf is bash-sourced. Keys used here:
#   gcp_project                project ID; the gcloud configuration of that name is activated (required)
#   gcp_service                Cloud Run service name (required)
#   gcp_region                 region (required)
#   gcp_apis                   bash array of APIs to enable, e.g.
#                              (run.googleapis.com secretmanager.googleapis.com);
#                              the ones a source deploy needs are always added
#   gcp_service_account        email of the app's service account; created if
#                              missing (the part before @ is the account id)
#   gcp_service_account_roles  bash array of project roles to grant it
#   gcp_sql_instance           Cloud SQL instance to create, with
#   gcp_sql_args               bash array of `gcloud sql instances create` flags
#                              (tier, edition, storage, ...; region is added)
#   gcp_db_name, gcp_db_user   database and user to create in it; the user's
#                              password is generated into the secret
#                              <gcp_service>-db-pass
#   gcp_secrets                bash array of "<secret-name>=<source>" where
#                              source is one of
#                                pass:<entry>       from the password store: the
#                                                   entry's first line (pass's
#                                                   convention; later lines are
#                                                   notes such as client_id:)
#                                random:hex:<n>     n random bytes as hex
#                                random:base64:<n>  n random bytes, base64,
#                                                   stripped of / + =
#                              created only if the secret does not exist yet
#
# Cost warning: a Cloud SQL instance is billed per hour whether or not the
# app is used.

if [[ "$#" -ne 0 ]]
then
	echo "$0: this script takes no arguments" >&2
	exit 1
fi

if [[ ! -r .gcp.conf ]]
then
	echo "${0}: no .gcp.conf in ${PWD}; run from the repository root" >&2
	exit 1
fi
gcp_apis=()
gcp_service_account_roles=()
gcp_sql_args=()
gcp_secrets=()
# shellcheck source=/dev/null
source .gcp.conf
: "${gcp_project:?must be set in .gcp.conf}"
: "${gcp_service:?must be set in .gcp.conf}"
: "${gcp_region:?must be set in .gcp.conf}"
export CLOUDSDK_ACTIVE_CONFIG_NAME="${gcp_project}"

project="${gcp_project}"
number="$(gcloud projects describe "${project}" --format 'value(projectNumber)')"
echo "project ${project} (${number})"

echo "== enabling APIs"
# `gcloud run deploy --source` builds with Cloud Build into Artifact Registry.
apis=(run.googleapis.com cloudbuild.googleapis.com artifactregistry.googleapis.com "${gcp_apis[@]}")
if [[ -n "${gcp_sql_instance:-}" ]]
then
	apis+=(sqladmin.googleapis.com)
fi
if [[ -n "${gcp_sql_instance:-}" || "${#gcp_secrets[@]}" -gt 0 ]]
then
	apis+=(secretmanager.googleapis.com)
fi
gcloud services enable "${apis[@]}"

# `gcloud run deploy --source` builds as the compute default service account.
# Projects created since 2024 no longer give it Editor, so it gets the one
# role a source deploy needs.
echo "== build service account"
gcloud projects add-iam-policy-binding "${project}" \
	--member "serviceAccount:${number}-compute@developer.gserviceaccount.com" \
	--role roles/run.builder \
	--condition None \
	--quiet > /dev/null 2>&1
echo "granted roles/run.builder to ${number}-compute@developer.gserviceaccount.com"

if [[ -n "${gcp_service_account:-}" ]]
then
	echo "== service account ${gcp_service_account}"
	if ! gcloud iam service-accounts describe "${gcp_service_account}" > /dev/null 2>&1
	then
		gcloud iam service-accounts create "${gcp_service_account%%@*}" \
			--display-name "${gcp_service} Cloud Run service"
	fi
	for role in "${gcp_service_account_roles[@]}"
	do
		# prints the whole policy on success; failures still stop the script
		gcloud projects add-iam-policy-binding "${project}" \
			--member "serviceAccount:${gcp_service_account}" \
			--role "${role}" \
			--condition None \
			--quiet > /dev/null 2>&1
		echo "granted ${role}"
	done
	# Cloud Build deploys as the compute default service account and must be
	# allowed to act as the app's.
	gcloud iam service-accounts add-iam-policy-binding "${gcp_service_account}" \
		--member "serviceAccount:${number}-compute@developer.gserviceaccount.com" \
		--role roles/iam.serviceAccountUser \
		--quiet > /dev/null 2>&1
	echo "Cloud Build may act as it"
fi

# create_secret_if_missing NAME: creates the secret when it is missing and sets
# secret_created to true when it was created now and still needs its first
# version, false when it already existed. It always returns 0 (a failed create
# stops the script): it is called on its own, never in a condition, so that
# set -e stays in force inside it.
secret_created=false
create_secret_if_missing() {
	if gcloud secrets describe "${1}" > /dev/null 2>&1
	then
		echo "secret ${1} exists"
		secret_created=false
		return 0
	fi
	gcloud secrets create "${1}" --replication-policy automatic
	secret_created=true
}

if [[ -n "${gcp_sql_instance:-}" ]]
then
	: "${gcp_db_name:?must be set in .gcp.conf with gcp_sql_instance}"
	: "${gcp_db_user:?must be set in .gcp.conf with gcp_sql_instance}"
	echo "== Cloud SQL instance ${gcp_sql_instance}"
	if ! gcloud sql instances describe "${gcp_sql_instance}" > /dev/null 2>&1
	then
		gcloud sql instances create "${gcp_sql_instance}" --region "${gcp_region}" "${gcp_sql_args[@]}"
	fi
	if ! gcloud sql databases describe "${gcp_db_name}" --instance "${gcp_sql_instance}" > /dev/null 2>&1
	then
		gcloud sql databases create "${gcp_db_name}" --instance "${gcp_sql_instance}"
	fi
	create_secret_if_missing "${gcp_service}-db-pass"
	if [[ "${secret_created}" == true ]]
	then
		db_pass="$(openssl rand -base64 30)"
		db_pass="${db_pass//[\/+=]/}"
		printf '%s' "${db_pass}" | gcloud secrets versions add "${gcp_service}-db-pass" --data-file -
		sql_users="$(gcloud sql users list --instance "${gcp_sql_instance}" --format 'value(name)')"
		if grep -qx "${gcp_db_user}" <<< "${sql_users}"
		then
			gcloud sql users set-password "${gcp_db_user}" --instance "${gcp_sql_instance}" --password "${db_pass}"
		else
			gcloud sql users create "${gcp_db_user}" --instance "${gcp_sql_instance}" --password "${db_pass}"
		fi
	fi
fi

if [[ "${#gcp_secrets[@]}" -gt 0 ]]
then
	echo "== secrets"
	for entry in "${gcp_secrets[@]}"
	do
		name="${entry%%=*}"
		source_spec="${entry#*=}"
		create_secret_if_missing "${name}"
		if [[ "${secret_created}" != true ]]
		then
			continue
		fi
		case "${source_spec}" in
			pass:*)
				secret_text="$(pass show "${source_spec#pass:}")"
				printf '%s' "${secret_text%%$'\n'*}" | gcloud secrets versions add "${name}" --data-file -
				;;
			random:hex:*)
				secret_text="$(openssl rand -hex "${source_spec#random:hex:}")"
				printf '%s' "${secret_text}" | gcloud secrets versions add "${name}" --data-file -
				;;
			random:base64:*)
				secret_text="$(openssl rand -base64 "${source_spec#random:base64:}")"
				printf '%s' "${secret_text//[\/+=]/}" | gcloud secrets versions add "${name}" --data-file -
				;;
			*)
				echo "${0}: unknown secret source '${source_spec}' for ${name} in gcp_secrets" >&2
				exit 1
				;;
		esac
	done
fi

echo "== done; deploy with gcloud_deploy.sh"
