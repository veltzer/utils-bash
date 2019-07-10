#!/bin/bash
find -L . -type f -exec chmod 444 '{}' \+
find -L . -type d -exec chmod 755 '{}' \+
