#!/usr/bin/env bash
set -e -o pipefail

source env/$1.env

ssh -i $SSH_KEY_PATH pveuser@$K3S_SERVER_NODE_IP "sudo /usr/local/bin/k3s-uninstall.sh"

for AGENT_NODE_IP in "${K3S_SERVER_AGENT_NODES_IPS[@]}"; do
  ssh -i $SSH_KEY_PATH pveuser@$AGENT_NODE_IP "sudo /usr/local/bin/k3s-agent-uninstall.sh"
done
