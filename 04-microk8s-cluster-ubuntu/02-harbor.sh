#!/usr/bin/env bash
set -e

helm repo add harbor https://helm.goharbor.io
helm install harbor harbor/harbor --namespace harbor --create-namespace --set expose.type=clusterIP --set expose.tls.auto.commonName=harbor --set expose.clusterIP.name=harbor 
