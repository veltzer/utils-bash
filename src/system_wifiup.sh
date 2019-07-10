#!/bin/bash
sudo ifconfig eth0 down
sudo ifdown eth0
sudo ifconfig eth1 down
sudo ifdown eth1
sudo ifup eth1=home-wireless
