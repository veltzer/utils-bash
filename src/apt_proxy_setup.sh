#!/bin/bash -eu

if [ "$#" -ne 0 ]
then
	echo "$0: this script takes no arguments" >&2
	exit 1
fi

# shellcheck disable=SC2154
if [ -z "${http_proxy}" ] || [ -z "${https_proxy}" ]
then
	echo "This script must be called when proxy variables are set"
	exit 1
fi
sudo bash -c "cat << EOF > /etc/apt/apt.conf.d/21proxy
Acquire {
  HTTP::proxy \"${http_proxy}\";
  HTTPS::proxy \"${https_proxy}\";
}
EOF"
