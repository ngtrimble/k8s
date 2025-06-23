#!/usr/bin/env bash
set -e

function usage() {
	echo "$0 METALLB_IPADDRESSPOOL NGINX_LB_IP"
	exit 1
}

if [[ -z "$1" ]]; then
	usage
fi

if [[ -z "$2" ]]; then
	usage
fi

# This is a reserved pool of *unused* IP addresses that MetalLB will use
# to send gratuitus ARP requests to a single node in the cluster acting
# as the leader. kube-proxy or in the case of microk8s, daemon-kubelite, 
# then forwards the request to a node running the nginx application.
# An exmaple of an METALLB_IPADDRESSPOOL is 192.168.0.10-192.168.0.19
METALLB_IPADDRESSPOOL=$1
# An exmaple of an NGINX_LB_IP is 192.168.0.10. It should be an IP 
# within the range of METALLB_IPADDRESSPOOL. 
NGINX_LB_IP=$2

sudo snap install microk8s --classic
sudo snap alias microk8s.kubectl kubectl
sudo snap alias microk8s.helm3 helm

# TODO - this introduces a bug where the shell needs to exit and login
# and the script re-run. Look for a method of becoming the user with 
# the group in this current session. Tools to try and use are 'su - $USER'
# and newgrp, however both of them have problems where the script does not
# continue with that session. 
sudo usermod -a -G microk8s $USER 
mkdir -p $HOME/.kube
sudo microk8s.kubectl config view --raw > $HOME/.kube/config
sudo chown -R $USER:$USER $HOME/.kube 

microk8s enable dns
microk8s enable cert-manager
microk8s enable metallb:$METALLB_IPADDRESSPOOL
microk8s enable ingress

NGINX_LB_DEFINITION=$(
cat << EOF
apiVersion: v1
kind: Service
metadata:
  name: ingress
  namespace: ingress
spec:
  selector:
    name: nginx-ingress-microk8s
  type: LoadBalancer
  loadBalancerIP: $NGINX_LB_IP 
  ports:
    - name: http
      protocol: TCP
      port: 80
      targetPort: 80
    - name: https
      protocol: TCP
      port: 443
      targetPort: 443
EOF
)

echo "$NGINX_LB_DEFINITION" | kubectl apply -f -

microk8s enable hostpath-storage
