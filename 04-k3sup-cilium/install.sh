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

K3S_SERVER_EXTRA_ARGS='--flannel-backend=none --disable-network-policy --disable-kube-proxy --disable servicelb --disable traefik --node-taint node.cilium.io/agent-not-ready=true:NoSchedule'
K3S_AGENT_EXTRA_ARGS='--flannel-backend=none --node-taint node.cilium.io/agent-not-ready=true:NoSchedule'

# Use k3sup to:
# * Install K3S on the first server node using ssh
# * --cluster flag uses etcd as the datastore for K3S, which is required for HA control plane nodes
# * --tls-san flag adds the VIP as a Subject Alternative Name (SAN) to the TLS certificate used by the K3S API server
k3sup install --cluster \
  --ip ${K3S_SERVER_NODES_IPS[0]} \
  --tls-san $K8S_HA_API_VIP \
  --user pveuser --ssh-key $SSH_KEY_PATH \
  --local-path $KUBECONFIG \
  --k3s-extra-args "$K3S_SERVER_EXTRA_ARGS"

sleep 30

helm repo add cilium https://helm.cilium.io/
helm repo update

kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/gateway-api/${GATEWAY_API_VERSION}/config/crd/standard/gateway.networking.k8s.io_gatewayclasses.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/gateway-api/${GATEWAY_API_VERSION}/config/crd/standard/gateway.networking.k8s.io_gateways.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/gateway-api/${GATEWAY_API_VERSION}/config/crd/standard/gateway.networking.k8s.io_httproutes.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/gateway-api/${GATEWAY_API_VERSION}/config/crd/standard/gateway.networking.k8s.io_referencegrants.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/gateway-api/${GATEWAY_API_VERSION}/config/crd/standard/gateway.networking.k8s.io_grpcroutes.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/gateway-api/${GATEWAY_API_VERSION}/config/crd/experimental/gateway.networking.k8s.io_tlsroutes.yaml

helm install cilium cilium/cilium --version $CILIUM_VERSION \
  --namespace kube-system \
  --set kubeProxyReplacement=true \
  --set k8sServiceHost=$K8S_HA_API_VIP \
  --set k8sServicePort=6443 \
  --set ingressController.enabled=true \
  --set ingressController.loadbalancerMode=shared \
  --set gatewayAPI.enabled=true \
  --set ipam.mode=cluster-pool \
  --set ipam.operator.clusterPoolIPv4PodCIDRList='{10.42.0.0/16}' \
  --set ipam.operator.clusterPoolIPv4MaskSize=24

for SERVER_NODE_IP in "${K3S_SERVER_NODES_IPS[@]:1}"; do
  k3sup join --server --ip $SERVER_NODE_IP --server-ip $K8S_HA_API_VIP --tls-san $K8S_HA_API_VIP \
    --user pveuser --ssh-key $SSH_KEY_PATH --k3s-extra-args "$K3S_SERVER_EXTRA_ARGS"
done

for AGENT_NODE_IP in "${K3S_AGENT_NODES_IPS[@]}"; do
  k3sup join --ip $AGENT_NODE_IP --server-ip $K8S_HA_API_VIP --tls-san $K8S_HA_API_VIP \
    --user pveuser --ssh-key $SSH_KEY_PATH --k3s-extra-args "$K3S_AGENT_EXTRA_ARGS"
done

kubectl get nodes -o wide

echo -e "Set your KUBECONFIG environment variable: \n\n\texport KUBECONFIG=$(pwd)/$ENV-kubeconfig\n"
