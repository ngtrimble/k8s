#!/usr/bin/env bash
set -e -o pipefail

# Creates a MetalLB LoadBalancer for external cluster access 
METALLB_IPADDRESSPOOL=192.168.68.20/32
NGINX_LB_IP=192.168.68.20
NGINX_INGRESS_VERSION="v1.13.3"

# Use Helm to install MetalLb. The Helm chart supports 
# loadBalancerClassi (https://kubernetes.io/docs/concepts/services-networking/service/#load-balancer-class). 
helm repo add metallb https://metallb.github.io/metallb
helm repo update
sudo helm upgrade metallb metallb/metallb \
	--install --namespace metallb-system --create-namespace

sudo kubectl rollout status deployment/metallb-controller -n metallb-system

# Configure MetalLB IPAddressPool and L2Advertisement
cat << EOF | sudo kubectl apply -f -
apiVersion: metallb.io/v1beta1
kind: IPAddressPool
metadata:
  name: external-lan-pool
  namespace: metallb-system
spec:
  addresses:
  - $METALLB_IPADDRESSPOOL
EOF

cat << EOF | sudo kubectl apply -f -
apiVersion: metallb.io/v1beta1
kind: L2Advertisement
metadata:
  name: external-lan-advertisement
  namespace: metallb-system
spec:
  ipAddressPools:
  - external-lan-pool
  nodeSelectors:
  - matchLabels:
      l2.advertised.metallb: "true"
EOF

# Install ingress-nginx configured with a LoadBalancer provided by MetalLB
sudo helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
sudo helm repo update
sudo helm upgrade ingress-nginx ingress-nginx/ingress-nginx \
	--install --create-namespace --namespace ingress-nginx \
	--set controller.service.type=LoadBalancer \
	--set controller.service.loadBalancerIP=$NGINX_LB_IP \

