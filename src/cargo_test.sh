#!/bin/bash -eu
cargo nextest run
cargo nextest run --release
