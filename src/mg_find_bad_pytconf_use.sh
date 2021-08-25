#!/bin/bash -e
pymultigit grep --regexp "from pytconf.config import" | grep -v pytconf/pytconf
