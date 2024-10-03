#!/bin/bash -e
curl https://sdk.cloud.google.com | bash
gcloud auth login
gcloud components update
