#!/bin/bash -eu

gh run list --repo veltzer/demos-os-linux --limit 1 --json conclusion --jq '.[0].conclusion'
