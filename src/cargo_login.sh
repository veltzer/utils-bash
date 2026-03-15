#!/bin/bash -eu

# Loging to cargo with my token

cargo login "$(pass show keys/crates.io)"
