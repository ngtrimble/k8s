#!/usr/bin/env bash
set -ex -o pipefail
shopt -s expand_aliases

usage() {
    echo "Usage: $0 ENV"
    exit 1
}

if [ -z "$1" ]; then
    usage
fi
export ENV=$1
source env/$ENV.env


scp -i $SSH_KEY_PATH traefik-config.yaml pveuser@${K3S_SERVER_NODES_IPS[0]}:/tmp/traefik-config.yaml

ssh -i $SSH_KEY_PATH pveuser@${K3S_SERVER_NODES_IPS[0]} <<EOF
sudo mv /tmp/traefik-config.yaml /var/lib/rancher/k3s/server/manifests/traefik-config.yaml
sudo chown root:root /var/lib/rancher/k3s/server/manifests/traefik-config.yaml
sudo chmod 600 /var/lib/rancher/k3s/server/manifests/traefik-config.yaml
sudo touch /var/lib/rancher/k3s/server/manifests/traefik-config.yaml
EOF
