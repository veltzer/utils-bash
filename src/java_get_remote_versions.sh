#!/bin/bash -eu

: <<'COMMENT'

This script shows you what jdk/jre java versions are there in the ubuntu repository.

COMMENT

apt-cache search openjdk | grep -- -jdk
