#!/bin/bash -e
# --verbosity=info --version=1
gcloud app deploy --promote --stop-previous-version --quiet
# TODO: remove the old version that does not get any more traffic
