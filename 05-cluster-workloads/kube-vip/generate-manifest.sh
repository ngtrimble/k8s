#!/usr/bin/env bash
set -e -o pipefail
shopt -s expand_aliases

curl -sL -O https://kube-vip.io/manifests/rbac.yaml
curl -sl -O https://raw.githubusercontent.com/kube-vip/kube-vip-cloud-provider/main/manifest/kube-vip-cloud-controller.yaml

export INTERFACE=$1

KVVERSION=$(curl -sL https://api.github.com/repos/kube-vip/kube-vip/releases | jq -r ".[0].name")
alias kube-vip="nerdctl run --network host --rm ghcr.io/kube-vip/kube-vip:$KVVERSION"

kube-vip manifest daemonset \
    --interface $INTERFACE \
    --inCluster \
    --taint \
    --services \
    --arp \
    --leaderElection > kube-vip-daemonset.yaml
