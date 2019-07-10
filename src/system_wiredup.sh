#!/bin/bash
sudo ifconfig eth1 down
sudo ifdown eth1
sudo ifconfig eth0 down
sudo ifdown eth0
sudo ifup eth0=generic-dhcp
