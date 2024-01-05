#!/bin/bash -e

: <<'COMMENT'

Show which java versions we have installed

COMMENT

# update-alternatives  --list java
update-java-alternatives --list
