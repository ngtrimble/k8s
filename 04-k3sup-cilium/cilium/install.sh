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

GENERATED_CILIUM_MANIFESTS="generated-cilium-manifests.yaml"

helm repo add cilium https://helm.cilium.io/

helm upgrade --install cilium cilium/cilium \
    --create-namespace \
    --namespace kube-system \
    --version $CILIUM_VERSION \
    --set operator.replicas=1

# TODO - this is from Claude. It seems most of the customizations defaults. 
# To get the set of options for this helm chart, run 
#
# `helm show values cilium/cilium --version $CILIUM_VERSION > cilium-values.yaml`
#
# helm template cilium cilium/cilium --version $CILIUM_VERSION \
#   --namespace kube-system \
#   --set operator.replicas=2 \
#   --set ipam.mode=kubernetes \
#   --set routingMode=native \
#   --set ipv4NativeRoutingCIDR=$CLUSTER_CIDR \
#   --set autoDirectNodeRoutes=true \
#   --set bpf.masquerade=true \
#   --set bpf.hostLegacyRouting=false \
#   --set kubeProxyReplacement=true \
#   --set k8sServiceHost=${K3S_SERVER_NODES_IPS[0]} \
#   --set k8sServicePort=6443 \
#   --set hubble.enabled=true \
#   --set hubble.relay.enabled=true \
#   --set hubble.ui.enabled=true \
#   --set hubble.metrics.enableOpenMetrics=true \
#   --set 'hubble.metrics.enabled={dns,drop,tcp,flow,icmp,httpV2:exemplars=true}' \
#   --set mtu=9000 \
#   --set enableIPv6Masquerade=false \
#   --set ipv6.enabled=false > $GENERATED_CILIUM_MANIFESTS

# scp -i $SSH_KEY_PATH $GENERATED_CILIUM_MANIFESTS pveuser@${K3S_SERVER_NODES_IPS[0]}:/tmp/cilium-manifests.yaml

# ssh -i $SSH_KEY_PATH pveuser@${K3S_SERVER_NODES_IPS[0]} <<EOF
# #!/usr/bin/env bash
# set -e -o pipefail
# sudo mkdir -p /var/lib/rancher/k3s/server/manifests/
# sudo mv /tmp/cilium-manifests.yaml /var/lib/rancher/k3s/server/manifests/
# sudo chown root:root /var/lib/rancher/k3s/server/manifests/cilium-manifests.yaml
# sudo chmod 600 /var/lib/rancher/k3s/server/manifests/cilium-manifests.yaml
# # Touch the file to trigger helm controller to pick up the new manifest
# sudo touch /var/lib/rancher/k3s/server/manifests/cilium-manifests.yaml
# EOF
