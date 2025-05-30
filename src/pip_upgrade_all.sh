#!/bin/bash -eu

# This will upgrade all the pip modules that can be upgraded
pip list --outdated --format=columns | cut -d " " -f 1 | xargs -n1 pip install --upgrade
