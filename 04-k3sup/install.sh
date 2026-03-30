#!/usr/bin/env bash
set -e -o pipefail
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

# TODO - remove this code 
rm ~/.ssh/known_hosts

# Install kube-vip before joining agent nodes to ensure the VIP is available for the agent nodes to join the cluster
pushd kube-vip
./install.sh $ENV
popd

k3sup install --ip $K3S_SERVER_NODE_IP --tls-san $VIP --user pveuser --ssh-key $SSH_KEY_PATH --k3s-extra-args "--disable servicelb" --local-path $KUBECONFIG
kubectl config use-context default

kubectl wait --namespace=kube-system --for=condition=Ready pods --all --timeout=300s
kubectl rollout status -n kube-system --timeout 300s ds/kube-vip-ds 

for AGENT_NODE_IP in "${K3S_SERVER_AGENT_NODES_IPS[@]}"; do
  k3sup join --ip $AGENT_NODE_IP --server-ip $VIP --user pveuser --ssh-key $SSH_KEY_PATH --k3s-extra-args "--disable servicelb"
done

kubectl get nodes

echo -e "Set your KUBECONFIG environment variable: \n\n\texport KUBECONFIG=$(pwd)/$ENV-kubeconfig\n"
