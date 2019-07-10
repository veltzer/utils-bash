#!/bin/bash

if [[ $HOSTNAME = 'fermat' ]]; then
	unison . ssh://mark@abel:22/$PWD
fi
if [[ $HOSTNAME = 'abel' ]]; then
	unison . ssh://mark@fermat:22/$PWD
fi
