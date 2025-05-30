#!/bin/bash -eu

: <<'COMMENT'

This will select the version of java you want using the alternative system.

COMMENT

sudo update-java-alternatives --list
sudo update-java-alternatives --set
sudo update-java-alternatives --set java-1.22.0-openjdk-amd64
