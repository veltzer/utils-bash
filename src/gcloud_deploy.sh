#!/bin/bash -e
# --verbosity=info --version=1
gcloud app deploy --promote --stop-previous-version --quiet
