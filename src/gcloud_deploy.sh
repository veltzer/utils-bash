#!/bin/bash -e
# --verbosity=info
gcloud app deploy --promote --stop-previous-version --version=1 --quiet
