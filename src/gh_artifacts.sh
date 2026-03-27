#!/bin/bash
gh release view --json assets --jq '.assets[] | "\(.name)\t\(.size)\t\(.downloadCount)"' | column -t -N NAME,SIZE,DOWNLOADS
