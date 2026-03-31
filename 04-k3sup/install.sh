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

# Install kube-vip before joining agent nodes to ensure the K8S API is available from the VIP for the agent nodes to join the cluster
pushd kube-vip
./install.sh $ENV
popd

pushd helm-customizations
./install.sh $ENV
popd

# Use k3sup to:
# * Install K3S on the first server node using ssh
# * --cluster flag uses etcd as the datastore for K3S, which is required for HA control plane nodes
# * --tls-san flag adds the VIP as a Subject Alternative Name (SAN) to the TLS certificate used by the K3S API server
k3sup install --cluster --ip ${K3S_SERVER_NODES_IPS[0]} --tls-san $K8S_HA_API_VIP --user pveuser --ssh-key $SSH_KEY_PATH --local-path $KUBECONFIG --k3s-extra-args '--disable servicelb'

for SERVER_NODE_IP in "${K3S_SERVER_NODES_IPS[@]:1}"; do
  k3sup join --server --ip $SERVER_NODE_IP --server-ip $K8S_HA_API_VIP --tls-san $K8S_HA_API_VIP --user pveuser --ssh-key $SSH_KEY_PATH --k3s-extra-args '--disable servicelb'
done

sleep 10
kubectl rollout status -n kube-system --timeout 60s daemonset/kube-vip-ds

for AGENT_NODE_IP in "${K3S_AGENT_NODES_IPS[@]}"; do
  k3sup join --ip $AGENT_NODE_IP --server-ip $K8S_HA_API_VIP --user pveuser --ssh-key $SSH_KEY_PATH
done

kubectl get nodes

echo -e "Set your KUBECONFIG environment variable: \n\n\texport KUBECONFIG=$(pwd)/$ENV-kubeconfig\n"
