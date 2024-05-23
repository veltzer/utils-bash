#!/bin/bash

sudo systemctl unmask snapd.service
sudo systemctl unmask snapd.socket
sudo systemctl unmask snapd.seeded.service
sudo systemctl enable snapd.service
sudo systemctl enable snapd.socket
sudo systemctl enable snapd.seeded.service
