# README.md

## Introduction

k3sup is an open source utility that automates installation of k3s clusters

## Prerequisites

* Install an OS compatible with k3s on 1 or more virtual or bare metal machines, See also [../01-proxmox/02-centos-k3s-cluster](../01-proxmox/02-centos-k3s-cluster)

* Install k3sup using the instructions at https://github.com/alexellis/k3sup 

## Set ENV variables

```shell
export K3S_SERVER_NODE_IP="192.168.68.20"
export K3S_SERVER_AGENT_NODES_IPS=("192.168.68.21" "192.168.68.22")
```

## Create cluster with single control plane

```shell
cd 04-k3sup
k3sup install --ip $K3S_SERVER_NODE_IP --user pveuser --ssh-key ../01-proxmox/02-centos-k3s-cluster/env/dev/dev-ssh-key --local-path ./dev-kubeconfig
```

## Add an an agent / worker node

```shell
export KUBECONFIG=/Users/nate/Projects/k8s/04-k3sup/dev-kubeconfig
kubectl config use-context default
kubectl get node -o wide
for NODE in "${K3S_SERVER_AGENT_NODES_IPS[@]}"
do
k3sup join --user pveuser --ip $NODE --server-ip $K3S_SERVER_NODE_IP --server-user pveuser --ssh-key ../01-proxmox/02-centos-k3s-cluster/env/dev/dev-ssh-key
done
```
