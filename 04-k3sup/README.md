# README.md

## Introduction

k3sup is an open source utility that automates installation of k3s clusters

## Prerequisites

* Install an OS compatible with k3s on 1 or more virtual or bare metal machines, See also [../01-proxmox/02-centos-k3s-cluster](../01-proxmox/02-centos-k3s-cluster)

* Install k3sup using the instructions at https://github.com/alexellis/k3sup 

## Creating a new cluster with commands

### Set ENV variables

```shell
source env/dev.env
```

Example env file

```shell
% cat env/dev.env
export K3S_SERVER_NODE_IP="192.168.1.20"
export K3S_SERVER_AGENT_NODES_IPS=("192.168.1.21" "192.1.68.22")
export SSH_KEY_PATH="../01-proxmox/02-ubuntu-k3s-cluster/env/dev/dev-ssh-key"
export KUBECONFIG="./dev-kubeconfig"
```

### Create cluster with single node control plane

```shell
k3sup install --ip $K3S_SERVER_NODE_IP --user pveuser --ssh-key ../01-proxmox/02-centos-k3s-cluster/env/dev/dev-ssh-key --local-path ./dev-kubeconfig
```

OR

### Create a cluster with, a multi-node (HA Cluster) control plane

This will cause k3s to use its embedded version of etcd to store cluster resource objects instead of the default of sqlite

```shell
k3sup install --cluster --ip $K3S_SERVER_NODE_IP --user pveuser --ssh-key ../01-proxmox/02-centos-k3s-cluster/env/dev/dev-ssh-key --local-path ./dev-kubeconfig 
```

### Add an an agent / worker node

```shell
export KUBECONFIG=/Users/nate/Projects/k8s/04-k3sup/dev-kubeconfig
kubectl config use-context default
kubectl get node -o wide
for NODE in "${K3S_SERVER_AGENT_NODES_IPS[@]}"
do
k3sup join --user pveuser --ip $NODE --server-ip $K3S_SERVER_NODE_IP --server-user pveuser --ssh-key ../01-proxmox/02-centos-k3s-cluster/env/dev/dev-ssh-key
done
```

## Creating a new cluster with script

```shell

```
