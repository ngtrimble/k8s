#!/usr/bin/env bash
set -e -o pipefail 

usage() {
cat << EOF
$0 [-u] [-h]

	-u - Uninstall k3s completely before installation or upgrade

	-a - k3s server arguments

	-h - Help or usage
EOF
exit 1
}

# These are default args for a k3s configuration that works with MetalLB on bare-metal installations
K3S_SERVER_ARGS="--disable=traefik --disable=servicelb --kube-proxy-arg proxy-mode=ipvs --kube-proxy-arg ipvs-strict-arp"
while getopts "a:hu" opt; do
	case $opt in
		a)
		K3S_SERVER_ARGS="$OPTARG"
		;;
		u) 
  		UNINSTALL=true
  		;;
		h)
		usage
		;;
		*)
		usage
		;;
	esac
done

if [[ -f "/usr/local/bin/k3s-uninstall.sh" && $UNINSTALL ]]; then
	read -p "This will uninstall k3s before installing it. Are you sure y/n?" CONFIRM 
	if [[ $CONFIRM == y ]]; then  
		/usr/local/bin/k3s-uninstall.sh
	else
		usage
	fi
fi

curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="server $K3S_SERVER_ARGS" sh -s -

# Copy k3s config to /root's $HOME.
sudo mkdir -p /root/.kube
sudo cp /etc/rancher/k3s/k3s.yaml /root/.kube/config
sudo chmod 644 /root/.kube/config

# Copy k3s config to $HOME
mkdir -p $HOME/.kube
sudo cp /etc/rancher/k3s/k3s.yaml $HOME/.kube/config
sudo chown $USER:$USER $HOME/.kube/config
sudo chmod 644 $HOME/.kube/config

cat << EOF
To use kubectl from the k3s distribution, set KUBECONFIG in your environment. Run:

printf "\nexport KUBECONFIG=~/.kube/config\n" >> ~/.profile

Your k3s join token is: 

$(sudo cat /var/lib/rancher/k3s/server/node-token)
EOF

