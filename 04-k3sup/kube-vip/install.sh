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

# Here we are using kube-vip to generate the DaemonSet manifest for the VIP, which we will apply 
# to the cluster. We need to do this before joining the agent nodes to ensure the VIP is 
# available for the agent nodes to join the cluster. Kube-vip runs from the container as a cli
# application in this case for convenience only. This can be done from any machine that has access 
# to docker or docker compatible runtime and kubectl.
kube-vip manifest daemonset \
    --interface $ARP_INTERFACE \
    --address $K8S_HA_API_VIP \
    --inCluster \
    --taint \
    --controlplane \
    --services \
    --arp \
    --leaderElection | tee base/kube-vip.yaml

pushd overlays/$ENV
# Use kustomize to build the final kube-vip manifest.
kustomize build . > ../../$GENERATED_KUBE_VIP
popd

# Only the first control plane node in the cluster needs the manifest copied. It will get imported
# by k3s to the cluster resources and be managed from there onwards. It must be copied to the first
# node in the cluster so that other nodes can join using the VIP and not the individual IP of the first 
# control plane node.
scp -i $SSH_KEY_PATH $GENERATED_KUBE_VIP pveuser@${K3S_SERVER_NODES_IPS[0]}:/tmp/kube-vip.yaml

ssh -i $SSH_KEY_PATH pveuser@${K3S_SERVER_NODES_IPS[0]} <<EOF
#!/usr/bin/env bash
set -e -o pipefail
sudo mkdir -p /var/lib/rancher/k3s/server/manifests/
sudo mv /tmp/kube-vip.yaml /var/lib/rancher/k3s/server/manifests/
sudo chown root:root /var/lib/rancher/k3s/server/manifests/kube-vip.yaml
sudo chmod 600 /var/lib/rancher/k3s/server/manifests/kube-vip.yaml
EOF
