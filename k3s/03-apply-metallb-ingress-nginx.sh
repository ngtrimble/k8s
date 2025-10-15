#!/usr/bin/env bash
set -e

# Creates a MetalLB LoadBalancer for external cluster access 
METALLB_IPADDRESSPOOL=192.168.68.20/32
NGINX_LB_IP=192.168.68.20
NGINX_INGRESS_VERSION="v1.13.3"

# Copy k3s config to root's profile. Helm needs this.
sudo mkdir -p /root/.kube
sudo cp /etc/rancher/k3s/k3s.yaml /root/.kube/config
sudo chmod 644 /root/.kube/config

# Install MetalLB
#METALLB_NS=$(
#cat << EOF
#apiVersion: v1
#kind: Namespace
#metadata:
#  name: metallb-system
#EOF
#)
#echo "$METALLB_NS" | sudo kubectl apply -f - 
#sudo kubectl create namespace metallb-system --dry-run=client -o yaml | tee /dev/tty | sudo kubectl apply -f -

# Use Helm to install MetalLb since the helm chart supports loadBalancerClass. 
helm repo add metallb https://metallb.github.io/metallb
sudo helm upgrade metallb metallb/metallb \
	--install --namespace metallb-system \
	--set loadBalancerClass=metallb --create-namespace 

sudo kubectl rollout status deployment/metallb-controller -n metallb-system

# Configure MetalLB IPAddressPool and LoadBalancer using MetalLB intended for use by ingress-nginx.
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
      kubernetes.io/hostname: k3s-01
EOF

# Install the ingress-nginx controller
sudo kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-$NGINX_INGRESS_VERSION/deploy/static/provider/baremetal/deploy.yaml

sudo kubectl rollout status deployment/ingress-nginx-controller -n ingress-nginx 

# Create a MetalLb LoadBalancer sending external traffic to ingress-nginx-controller 
cat << EOF | sudo kubectl apply -f -
apiVersion: v1
kind: Service
metadata:
  name: external-lb 
  namespace: ingress-nginx
spec:
  type: LoadBalancer
  loadBalancerClass: metallb
  loadBalancerIP: $NGINX_LB_IP 
  selector:
    name: ingress-nginx-controller
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

sudo kubectl rollout status deployment/ingress-nginx-controller -n ingress-nginx 

# Create a default Ingress
sudo kubectl create ingress --dry-run=client default-ingress --default-backend='default-web-service:8000' \
	--class=nginx -o yaml | \
	tee /dev/tty | sudo kubectl apply -f -

# Create a hello-world deployment and service to test the default ingress
sudo kubectl create deployment --dry-run=client --image crccheck/hello-world --port=8000 \
	-o yaml default-web-app | tee /dev/tty | sudo kubectl apply -f -
sudo kubectl create service clusterip default-web-service -o yaml --dry-run=client \
	--tcp="80:8000,443:8000" | tee /dev/tty | sudo kubectl apply -f -
