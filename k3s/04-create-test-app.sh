#!/usr/bin/env bash
set -e -o pipefail

# Create a hello-world deployment, service and ingress to test
sudo kubectl create deployment default-web-app --image crccheck/hello-world --port=8000 -n default
sudo kubectl expose deployment default-web-app -n default --type ClusterIP
sudo kubectl create ingress default-web-app -n default --default-backend='default-web-service:8000'
