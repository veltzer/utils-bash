#!/bin/bash -eu

# Loging to cargo with my token

# deprecated
# cargo login "$(pass show keys/crates.io)"
pass show keys/crates.io | cargo login
