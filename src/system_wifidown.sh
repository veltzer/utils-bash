#!/bin/bash -e
sudo ifdown eth1=home-wireless
sudo ifconfig eth1 down
