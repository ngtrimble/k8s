#!/usr/bin/env bash
set -e

helm repo add harbor https://helm.goharbor.io
helm install harbor/harbor --generate-name --namespace harbor --create-namespace
