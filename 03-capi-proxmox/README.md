# README.md

## Introduction

Use this if you would like to use Kubernetes Cluster API (CAPI) to manage Proxmox. This is an alternative or additive approach
to managing both Kubernetes Clusters and Virtual Machines as declaritive Kubernetes resources (e.g. .yaml manifests).

## Prerequistes

### Image Builder

For this step you must build an iso that will run your CAPI. Follow the steps found at 
https://image-builder.sigs.k8s.io/capi/providers/proxmox to build a VM template in your proxmox
installation. Note, you will need:

* Proxmox VM / Cluster
* A proxmox user to your cluster and an associated token, required permissions in the link above
* image-builder (https://github.com/kubernetes-sigs/image-builder/releases) downloaded to your machine
* make, python3, packer, ansible, etc (make-deps should mostly cover it)
* Environment variables set via source (e.g. 'source .env') or some other method

Here is an example of .env:

```shell
export PROXMOX_URL=https://HOST_OR_IP:8006/api2/json
# Format for PROXMOX_USERNAME USER@REALM!TOKEN_ID
export PROXMOX_USERNAME=capi@pve!capi
export PROXMOX_TOKEN=6d416cc1-c193-4f8d-b6d5-9bcf643494c3
export PROXMOX_NODE=proxmox1
export PROXMOX_ISO_POOL=local
export PROXMOX_STORAGE_POOL=local-lvm
export PROXMOX_BRIDGE=vmbr0
export PACKER_FLAGS="-var disk_format=raw"
```

Once you have an image built and saved up in Proxmox you can proceed to CAPI installation.

## Installation

