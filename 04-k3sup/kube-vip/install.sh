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
GENERATED_KUBE_VIP=generated-kube-vip.yaml

curl -sL -o base/rbac.yaml https://kube-vip.io/manifests/rbac.yaml
curl -sL -o base/kube-vip-cloud-controller.yaml https://raw.githubusercontent.com/kube-vip/kube-vip-cloud-provider/main/manifest/kube-vip-cloud-controller.yaml

KVVERSION=$(curl -sL https://api.github.com/repos/kube-vip/kube-vip/releases | jq -r ".[0].name")
alias docker="nerdctl"
alias kube-vip="docker run --network host --rm ghcr.io/kube-vip/kube-vip:$KVVERSION"

kube-vip manifest daemonset \
    --interface $INTERFACE \
    --address $VIP \
    --inCluster \
    --taint \
    --controlplane \
    --services \
    --arp \
    --leaderElection | tee base/kube-vip.yaml

pushd overlays/$ENV
kustomize build . > ../../$GENERATED_KUBE_VIP
popd

scp -i $SSH_KEY_PATH $GENERATED_KUBE_VIP pveuser@$K3S_SERVER_NODE_IP:/tmp/kube-vip.yaml

ssh -i $SSH_KEY_PATH pveuser@$K3S_SERVER_NODE_IP <<EOF
#!/usr/bin/env bash
set -e -o pipefail
sudo mkdir -p /var/lib/rancher/k3s/server/manifests/
sudo mv /tmp/kube-vip.yaml /var/lib/rancher/k3s/server/manifests/
EOF
