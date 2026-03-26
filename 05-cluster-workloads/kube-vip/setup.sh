#!/usr/bin/env bash
set -e -o pipefail

curl -s -L https://kube-vip.io/manifests/rbac.yaml > kube-vip-rbac.yaml
kubectl apply -f kube-vip-rbac.yaml

export VIP=192.168.68.12
export INTERFACE=ens160

KVVERSION=$(curl -sL https://api.github.com/repos/kube-vip/kube-vip/releases | jq -r ".[0].name")

alias kube-vip="ctr image pull ghcr.io/kube-vip/kube-vip:$KVVERSION; ctr run --rm --net-host ghcr.io/kube-vip/kube-vip:$KVVERSION vip /kube-vip"

kube-vip manifest daemonset \
    --interface $INTERFACE \
    --address $VIP \
    --inCluster \
    --taint \
    --controlplane \
    --services \
    --arp \
    --leaderElection
