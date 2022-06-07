#!/bin/bash -e
cd ~/install/bin
wget "https://github.com/openshift/okd/releases/download/4.7.0-0.okd-2021-03-28-152009/openshift-client-linux-4.7.0-0.okd-2021-03-28-152009.tar.gz"
tar xvf "openshift-client-linux-4.7.0-0.okd-2021-03-28-152009.tar.gz"
rm README.md "openshift-client-linux-4.7.0-0.okd-2021-03-28-152009.tar.gz"
