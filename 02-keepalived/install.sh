#!/usr/bin/env bash
set -ex -o pipefail

usage() {
    echo "Example: $0 ENV"
    exit 1
}

if [ -z "$1" ]; then
    usage
fi
export ENV=$1
source env/$ENV.env

for AGENT_NODE_IP in "${K3S_SERVER_AGENT_NODES_IPS[@]}"; do
  k3sup join --ip $AGENT_NODE_IP --server-ip $VIP --user pveuser --ssh-key $SSH_KEY_PATH --k3s-extra-args
done

INSTALL_SCRIPT=""
if [[ "$os" == "debian" ]]; then
    INSTALL_SCRIPT="02-install-keepalived-debian.sh"
elif [[ "$os" == "redhat" ]]; then
    INSTALL_SCRIPT="02-install-keepalived-redhat.sh"
else
    echo "Unsupported OS: $os"
    exit 1
fi

for NODE_IP in "${KEEEPALIVED_INSTALL_NODES[@]}"; do
  ssh -i $SSH_KEY_PATH pveuser@$NODE_IP "sudo bash -s" -- -l $LOADBALANCER_IP_MASK -i $INTERFACE < $INSTALL_SCRIPT
done
