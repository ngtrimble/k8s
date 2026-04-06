#!/usr/bin/env bash
set -e -o pipefail

source env/$1.env

for K3S_SERVER_NODE_IP in "${K3S_SERVER_NODES_IPS[@]}"; do
  ssh -i $SSH_KEY_PATH pveuser@$K3S_SERVER_NODE_IP "sudo /usr/local/bin/k3s-uninstall.sh"
done

for K3S_AGENT_NODE_IP in "${K3S_AGENT_NODES_IPS[@]}"; do
  ssh -i $SSH_KEY_PATH pveuser@$K3S_AGENT_NODE_IP "sudo /usr/local/bin/k3s-agent-uninstall.sh"
done
