#!/bin/bash -eu

# Run psql against the Cloud SQL (PostgreSQL) database of the current
# repository, through the Cloud SQL Auth Proxy with your gcloud credentials
# and with the app's own database password from Secret Manager, so there is
# nothing to type. Arguments go to psql; stdin is passed through, so both
# `gcloud_sql_psql.sh -c 'select 1'` and `gcloud_sql_psql.sh < file.sql`
# work, as does an interactive session with no arguments.
#
# .gcp.conf is bash-sourced. Keys used here:
#   gcp_configuration_name  gcloud configuration to activate (required)
#   gcp_sql_instance        Cloud SQL instance (required)
#   gcp_db_name, gcp_db_user database and user (required)
#   gcp_db_pass_secret      Secret Manager secret holding the user's password
#                           (default <gcp_service>-db-pass, as created by
#                           gcloud_project_setup.sh)
#
# psql runs with -X so ~/.psqlrc (timing and the like) does not add noise
# to scripted use. The proxy's own chatter goes to a log that is shown only
# when the connection fails.

if [[ ! -r .gcp.conf ]]
then
	echo "${0}: no .gcp.conf in $(pwd); run from the repository root" >&2
	exit 1
fi
# shellcheck source=/dev/null
source .gcp.conf
: "${gcp_configuration_name:?must be set in .gcp.conf}"
: "${gcp_sql_instance:?must be set in .gcp.conf}"
: "${gcp_db_name:?must be set in .gcp.conf}"
: "${gcp_db_user:?must be set in .gcp.conf}"
export CLOUDSDK_ACTIVE_CONFIG_NAME="${gcp_configuration_name}"
secret="${gcp_db_pass_secret:-${gcp_service:?must be set in .gcp.conf}-db-pass}"

# The Cloud SQL Auth Proxy and the postgres client are not part of the base SDK.
for tool in cloud-sql-proxy psql pg_isready
do
	if ! command -v "${tool}" > /dev/null
	then
		echo "${0}: ${tool} not found on PATH; install it first:" >&2
		echo "  cloud-sql-proxy: gcloud components install cloud-sql-proxy" >&2
		echo "  psql, pg_isready: apt install postgresql-client" >&2
		exit 1
	fi
done

PGPASSWORD="$(gcloud secrets versions access latest --secret "${secret}")"
export PGPASSWORD

# Run the proxy ourselves rather than through `gcloud sql connect`, which
# insists on prompting for the password on stdin, where the SQL may be.
connection_name="$(gcloud sql instances describe "${gcp_sql_instance}" --format 'value(connectionName)')"
port="${GCLOUD_SQL_PSQL_PORT:-54329}"
proxy_log="$(mktemp)"
cloud-sql-proxy --gcloud-auth --port "${port}" "${connection_name}" > "${proxy_log}" 2>&1 &
proxy_pid="${!}"
cleanup() {
	kill "${proxy_pid}" 2> /dev/null || true
	rm -f "${proxy_log}"
}
trap cleanup EXIT
for _ in $(seq 1 30)
do
	if pg_isready -h 127.0.0.1 -p "${port}" -q
	then
		break
	fi
	sleep 1
done
if ! pg_isready -h 127.0.0.1 -p "${port}" -q
then
	echo "${0}: could not reach ${connection_name} through the proxy:" >&2
	cat "${proxy_log}" >&2
	exit 1
fi

psql -X -h 127.0.0.1 -p "${port}" -U "${gcp_db_user}" -d "${gcp_db_name}" "${@}"
