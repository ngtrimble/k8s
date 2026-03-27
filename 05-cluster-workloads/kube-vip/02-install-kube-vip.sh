#!/usr/bin/env bash
set -e -o pipefail
shopt -s expand_aliases

cat << EOF
apiVersion: v1
kind: Service
metadata:
  name: external-lb
spec:
  type: LoadBalancer
  loadBalancerClass: kube-vip.io/kube-vip-class
  loadBalancerIP: 192.168.68.30
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
