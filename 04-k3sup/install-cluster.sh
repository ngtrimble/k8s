#!/usr/bin/env bash

source .env

k3sup install --ip $K3S_SERVER_NODE_IP --user pveuser --ssh-key $SSH_KEY_PATH --local-path $KUBECONFIG
kubectl config use-context default

for AGENT_NODE_IP in "${K3S_SERVER_AGENT_NODES_IPS[@]}"; do
  k3sup join --ip $AGENT_NODE_IP --server-ip $K3S_SERVER_NODE_IP --user pveuser --ssh-key $SSH_KEY_PATH
done

kubectl get nodes --kubeconfig $KUBECONFIG
