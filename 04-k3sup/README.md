# README.md

## Introduction

k3sup is a utility that makes automates installing k3s clusters simpler than the scripts provided in 
04-k3s-LoadBalancing. This document describes how to use it.

## Prerequisites

Create three nodes in your ProxMox environment using the 02-terraform/k3s-cluster. Make sure to copy the pve-user and 
pve-user.pub key pair to your local $HOME/.ssh directory. This key pair was generated in 
01-cloud-images/create-template.sh.

Install k3sup using the instructions at https://github.com/alexellis/k3sup or just use brew
https://formulae.brew.sh/formula/k3sup. 

## Create cluster with single control plane

## Create HA cluster

Run:

```
k3sup install --cluster --ip K3S_NODE_0_IP --user pve-user --ssh-key ~/.ssh/pve-key --k3s-channel stable
```

The --cluster flag is for a cluster with a multiple control plane nodes.

## Optional, add a second cluster server, AKA an additional control plane node

Run:

```
k3sup join --user pve-user --ip K3S_NODE_1_IP --server --server-ip K3S_NODE_0_IP --server-user pve-user --ssh-key ~/.ssh/pve-key
```

## Join the third node

k3sup join --user pve-user --ip K3S_NODE_2_IP --server-ip K3S_NODE_0_IP --ssh-key ~/.ssh/pve-key
