#!/bin/bash

<<'COMMENT'

This script installs the tip of the css-validator project

COMMENT

git clone --depth 1 --branch master git@github.com:w3c/css-validator.git
cd css-validator
ant
