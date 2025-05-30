#!/bin/bash -eu

: <<'COMMENT'

This script installs java on an ubuntu system.
You need to supply the version number.

COMMENT

version=$1
echo "version: ${version}"
sudo apt install\
	"openjdk-${version}-jdk"\
	"openjdk-${version}-jdk-headless"\
	"openjdk-${version}-jre"\
	"openjdk-${version}-jre-headless"\
	"openjdk-${version}-doc"
