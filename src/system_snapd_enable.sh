#!/bin/bash -e

sudo systemctl unmask snapd.service snapd.socket
sudo systemctl enable snapd.service snapd.socket
sudo systemctl start snapd.service snapd.socket
