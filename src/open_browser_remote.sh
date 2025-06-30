#!/bin/bash -eu

project=$(python -m "import config.project; print(config.project.name)")
# Open a browswer on the remote sight stuff
xdg-open "https://veltzer.github.io/${project}"
