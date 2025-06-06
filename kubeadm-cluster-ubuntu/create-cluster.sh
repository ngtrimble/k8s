#!/usr/bin/env bash
# 
# Creates a kubernetes cluster using kubeadm on Ubuntu. Last tested on Ubuntu 24.04. 
#
# * Uses https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm as a guide.
# * Not intended for actual use but for learning and experimentation with "Vanilla" Kubernetes.
# 
# * To re-run this script and re-create the K8S cluster, first execute `sudo kubeadm reset`
set -e

if [[ $EUID -ne 0 ]]; then
	echo "This script must be run as root."
	exit 1
fi

K8S_VERSION=v1.33
CALICO_VERSION=v3.30.1
NGINX_INGRESS_VERSION=v1.12.3
POD_NETWORK_CIDR=10.244.0.0/16

apt-get update 
apt-get install -y containerd apt-transport-https ca-certificates curl gpg
apt-get dist-upgrade -y

# Enable IPv4 packet forwarding
cat <<EOF | tee /etc/sysctl.d/k8s.conf
net.ipv4.ip_forward = 1
EOF

# Apply sysctl params without reboot
sysctl --system

# Install a Container Runtime Interface (CRI) from Ubuntu repositories. An OCI compatible v1 runtime is all that is needed.
mkdir -p /etc/containerd
# Ubuntu does not come with this file so we generate the default file. This is necessary because it needs to be modified below.
containerd config default > /etc/containerd/config.toml
# Adjust the group Cgroup driver to systemd that is used for processes started by its runtime (e.g. runc)
sed -i 's/SystemdCgroup \+= false/SystemdCgroup = true/g' /etc/containerd/config.toml
sed -i 's/sandbox_image \+=.*$/sandbox_image = \"registry\.k8s\.io\/pause\:3\.10\"/g' /etc/containerd/config.toml
systemctl restart containerd

# Install kubelet, kubeadm, and kubectl from k8s.io deb repos.
mkdir -p -m 755 /etc/apt/keyrings
curl -fsSL https://pkgs.k8s.io/core:/stable:/$K8S_VERSION/deb/Release.key | \
	gpg --yes --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/$K8S_VERSION/deb/ /" | tee /etc/apt/sources.list.d/kubernetes.list

apt-get update
apt-get install -y kubelet kubeadm kubectl
apt-mark hold kubelet kubeadm kubectl
systemctl enable --now kubelet

# Initialize a new kubernetes cluster
kubeadm init --pod-network-cidr=$POD_NETWORK_CIDR

export KUBECONFIG=/etc/kubernetes/admin.conf

# Allow pods to be scheduled on control plane nodes
kubectl taint nodes --all node-role.kubernetes.io/control-plane-

# Install a Container Network Interface (i.e. CNI)
kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/$CALICO_VERSION/manifests/operator-crds.yaml
kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/$CALICO_VERSION/manifests/tigera-operator.yaml
kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/$CALICO_VERSION/manifests/custom-resources.yaml

# calicoNetwork.ipPools.cidr must exist within --pod-network-cidr
CIDR_PATCH=$(cat <<EOF
spec:
  calicoNetwork:
    ipPools:
    - cidr: 10.244.0.0/16
EOF
)
kubectl patch installations.operator.tigera.io default --type merge -p "$CIDR_PATCH" 

# Install the Calico CLI (calicoctl)
pushd /usr/local/bin
curl -L https://github.com/projectcalico/calico/releases/download/$CALICO_VERSION/calicoctl-linux-amd64 -o calicoctl
chmod +x ./calicoctl
popd

# Install the latest ingress-nginx controller
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-$NGINX_INGRESS_VERSION/deploy/static/provider/baremetal/deploy.yaml

# Setup kubeconfig in current user's home directory, warning this overrites user's ~/.kube/config
# Sets SUDO_USER to root if this script was not run with sudo
SUDO_USER=${SUDO_USER:-$USER}
# Gets the SUDO_USER's home directory to be used below by root to copy the kubeconfig
SUDO_USER_HOME=$(eval echo ~$SUDO_USER)

su -l $SUDO_USER -c 'mkdir -p $HOME/.kube'
cp -i /etc/kubernetes/admin.conf $SUDO_USER_HOME/.kube/config
chown $(id -u $SUDO_USER):$(id -g $SUDO_USER) $SUDO_USER_HOME/.kube/config
