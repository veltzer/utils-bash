#!/bin/bash
for x in */Makefile; do echo $x; cat $x | grep make_helper; done
