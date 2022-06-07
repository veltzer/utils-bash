#!/bin/bash -e

if [ -f ~/install/bin/helm ]
then
	echo "you already have helm in ~/bin/helm"
	exit 1
fi
cd ~/install/bin
wget "https://get.helm.sh/helm-v3.6.1-linux-amd64.tar.gz" 
tar xf "helm-v3.6.1-linux-amd64.tar.gz" linux-amd64/helm
mv linux-amd64/helm .
rmdir linux-amd64
rm -f "helm-v3.6.1-linux-amd64.tar.gz"
