#!/bin/bash -eu
# dev_appserver.py app.yaml
gunicorn -b :8080 src.main:app
# gcloud beta emulators app run app.yaml
