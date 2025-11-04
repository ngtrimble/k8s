# README

Sets up a single node Kubernetes cluster with [kubeadm](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/).

## Features

* As "Vanilla" Kubernetes as it gets without resorting to [Kubernetes the Hard Way](https://github.com/kelseyhightower/kubernetes-the-hard-way).
* Tested on Ubuntu 24.04 LTS
* Uses containerd and runc from Ubuntu, does not require Docker
* Creates a default containerd configuration file and applies modifications
* Installs kubeadm, kubelet and kubectl from k8s.io
* Installs Calico as the CNI and properly demonstrates configuring the pod network cidr in the Calico CNI plugin
* Installs nginx-ingress controller to the cluster
* Supplies a script for resetting the cluster installation and CNI for troubleshooting

## Caveats

No one should really use this for anything beyond learning, development and experimentation. Prouction Kubernetes
is far better supported by many vendor implementations. 

