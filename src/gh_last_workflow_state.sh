#!/bin/bash -eu

PAGER= gh run list --repo veltzer/demos-os-linux --limit 1 --json conclusion --jq '.[0].conclusion'
