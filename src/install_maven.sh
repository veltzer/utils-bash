#!/bin/bash -eu

if [[ "$#" -ne 0 ]]
then
	echo "$0: this script takes no arguments" >&2
	exit 1
fi

# Fetch the latest Maven version from the Apache Maven download page
download_page=$(curl -s https://maven.apache.org/download.cgi)

# Extract the latest version using a more specific pattern
maven_name=$(grep -m 1 -o "apache-maven-[0-9\.]\+" <<< "${download_page}")
latest_version=$(grep -o "[0-9\.]\+" <<< "${maven_name}")

# Check if a version was found
if [[ -z "${latest_version}" ]]
then
    echo "Error: Could not determine the latest Maven version. Please check the Maven website or script."
    exit 1
fi

# echo "latest version is [${latest_version}]"

# Download the latest Maven version
wget -q "https://dlcdn.apache.org/maven/maven-3/${latest_version}/binaries/apache-maven-${latest_version}-bin.tar.gz" -P /tmp

# Extract the downloaded archive
tar xzf "/tmp/apache-maven-${latest_version}-bin.tar.gz" -C "${HOME}/install"

# Clean up the downloaded archive
rm "/tmp/apache-maven-${latest_version}-bin.tar.gz"

# Create a nice symlink
symlink="${HOME}/install/apache-maven"
if [[ -e "${symlink}" ]]
then
    # echo "${symlink} already exists. Removing..."
    rm "${symlink}"
fi
ln -s "apache-maven-${latest_version}" "${symlink}"
