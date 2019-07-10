#!/bin/bash

<<'COMMENT'

This script checks that there is no diff in the package selections

COMMENT

diff dpkg_selections.*
