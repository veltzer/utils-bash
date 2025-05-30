#!/bin/bash -eu

sudo systemctl stop snapd.service snapd.socket
sudo systemctl disable snapd.service snapd.socket
sudo systemctl mask snapd.service snapd.socket
