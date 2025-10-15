#!/usr/bin/env bash
set -e -o pipefail

export VIP=192.168.68.20
VIP_CIDR=$VIP/32
export INTERFACE=ens160

KVVERSION=$(curl -sL https://api.github.com/repos/kube-vip/kube-vip/releases | jq -r ".[0].name")

curl https://kube-vip.io/manifests/rbac.yaml > /var/lib/rancher/k3s/server/manifests/kube-vip-rbac.yaml

sudo kubectl apply -f https://raw.githubusercontent.com/kube-vip/kube-vip-cloud-provider/main/manifest/kube-vip-cloud-controller.yaml


sudo kubectl apply -f https://raw.githubusercontent.com/kube-vip/kube-vip-cloud-provider/main/manifest/kube-vip-cloud-controller.yaml
sudo kubectl create configmap -n kube-system kubevip --from-literal cidr-global=$VIP_CIDR

cat << EOF
apiVersion: v1
kind: Service
metadata:
  name: external-lb 
  namespace: ingress-nginx
spec:
  type: LoadBalancer
  loadBalancerClass: kube-vip.io/kube-vip-class
  loadBalancerIP: $VIP 
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


