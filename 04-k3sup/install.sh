#!/usr/bin/env bash
set -ex -o pipefail
shopt -s expand_aliases

usage() {
    echo "Example: $0 ENV"
    exit 1
}

if [ -z "$1" ]; then
    usage
fi
export ENV=$1
source env/$ENV.env

export KUBECONFIG=$(pwd)/$ENV-kubeconfig

# TODO - remove this
rm -f ~/.ssh/known_hosts

# Install kube-vip before joining agent nodes to ensure the VIP is available for the agent nodes to join the cluster
pushd kube-vip
./install.sh $ENV
popd

# TODO - this line should be used if the VIP is used 
#k3sup install --ip $K3S_SERVER_NODE_IP --tls-san $VIP --user pveuser --ssh-key $SSH_KEY_PATH --local-path $KUBECONFIG
k3sup install --ip $K3S_SERVER_NODE_IP --user pveuser --ssh-key $SSH_KEY_PATH --local-path $KUBECONFIG

for AGENT_NODE_IP in "${K3S_SERVER_AGENT_NODES_IPS[@]}"; do
  # TODO - this line used once the VIP is used for the k3s server installation and joining of agent nodes.
  #k3sup join --ip $AGENT_NODE_IP --server-ip $VIP --user pveuser --ssh-key $SSH_KEY_PATH
  k3sup join --ip $AGENT_NODE_IP --server-ip $K3S_SERVER_NODE_IP --user pveuser --ssh-key $SSH_KEY_PATH
done

kubectl get nodes

echo -e "Set your KUBECONFIG environment variable: \n\n\texport KUBECONFIG=$(pwd)/$ENV-kubeconfig\n"
