#!/bin/bash -e

# Fetch the latest Maven version from the Apache Maven download page
download_page=$(curl -s https://maven.apache.org/download.cgi)

# Extract the latest version using a more specific pattern
latest_version=$(echo "${download_page}" | grep -o "apache-maven-[0-9\.]\+" | head -n 1 | grep -o "[0-9\.]\+")

# Check if a version was found
if [ -z "${latest_version}" ]
then
    echo "Error: Could not determine the latest Maven version. Please check the Maven website or script."
    exit 1
fi

echo "latest version is [${latest_version}]"

# Download the latest Maven version
wget "https://dlcdn.apache.org/maven/maven-3/${latest_version}/binaries/apache-maven-${latest_version}-bin.tar.gz" -P /tmp

# Extract the downloaded archive
tar xzf "/tmp/apache-maven-${latest_version}-bin.tar.gz" -C "${HOME}/install"

# Clean up the downloaded archive
rm "/tmp/${latest_version}"

# Create a nice symlink
symlink="${HOME}/install/apache-maven"
if [ -e "${symlink}" ]
then
    echo "${symlink} already exists. Removing..."
    rm "${symlink}"
fi
ln -s "${HOME}/install/apache-maven-${latest_version}" "${symlink}"

