#!/bin/bash -eu
cargo build
cargo build --release
# cargo nextest run
# cargo nextest run --release
