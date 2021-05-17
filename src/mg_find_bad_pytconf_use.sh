#!/bin/bash
pymultigit grep --regexp "from pytconf.config import" | grep -v pytconf/pytconf
