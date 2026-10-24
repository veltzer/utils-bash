#!/bin/bash -eu

if [ "$#" -ne 0 ]
then
	echo "$0: this script takes no arguments" >&2
	exit 1
fi

# dev_appserver.py app.yaml
gunicorn -b :8080 src.main:app
# gcloud beta emulators app run app.yaml
