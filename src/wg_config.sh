#!/bin/bash -e

# shellcheck source=/dev/null
source ~/.wireguard_secrets

cat > /tmp/wireguard.conf <<EOF
[Interface]
PrivateKey = \$PrivateKey
Address = 172.32.0.4/24
# DNS = 169.254.169.253

[Peer]
PublicKey = \$PublicKey
AllowedIPs = 172.31.0.0/16, 10.0.0.0/8, 169.254.169.253/32
Endpoint = ec2-3-73-0-115.eu-central-1.compute.amazonaws.com:23894
EOF

sudo --preserve-env sh -c "envsubst < /tmp/wireguard.conf > /etc/wireguard/wireguard.conf"
