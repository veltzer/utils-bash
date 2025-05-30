#!/bin/bash -eu

: <<'COMMENT'

This script backs up your /etc folder (where 90% of your configuration lives)
and the selection of packages you are using...

COMMENT

# this script should not be run as root since it needs the user name to change
# the file ownership to...:)
if [[ "${USER}" == 'root' ]]
then
	echo "do not run me as root..."
	exit 1
fi

FOLDER="${HOME}/insync/backups/system"
TMP_ETC="/tmp/etc.${HOSTNAME}.tar.bz2"
TARGET_ETC="${FOLDER}/etc.${HOSTNAME}.tar.bz2"
TARGET_DPKG_SELECTIONS="${FOLDER}/dpkg_selections.${HOSTNAME}.txt"
TARGET_ALTERNATIVES="${FOLDER}/alternatives.${HOSTNAME}.txt"

# we sudo since we are running as regular user and cannot enter into some folders...
# we do not create the final output file but rather a file in /tmp because it will
# have root ownership and we want a file with mark ownership.
echo "creating [${TARGET_ETC}]..."
sudo tar --create --bzip2 --absolute-names --file "${TMP_ETC}" /etc
cp "${TMP_ETC}" "${TARGET_ETC}"
sudo rm "${TMP_ETC}"
# these two steps can be done by any user...
echo "creating [${TARGET_DPKG_SELECTIONS}]..."
dpkg --get-selections > "${TARGET_DPKG_SELECTIONS}"
echo "creating [${TARGET_ALTERNATIVES}]..."
update-alternatives --get-selections > "${TARGET_DPKG_SELECTIONS}"
