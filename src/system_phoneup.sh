#!/bin/bash
# put the phone on PCSUITE mode for this to work...
sudo ifdown eth0
sudo ifdown eth1
sudo pppd call gprs
