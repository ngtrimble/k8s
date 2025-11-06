# k8s

## Introduction

This repository contains scripts, IaC and configurations for installing Kubernetes in a Hybrid Cloud or On-prem 
Environment. The intent of these scripts and configurations is primarily for learning, demonstration and training
purposes. They can also be made use of for building a homelab. It would not be recomended to use this code for
production use without further development of your own fork of this repository.

## Stages

Directories (i.e. Stages) in this repository are labeled with a number that roughly matches an order they should be used in. No
one particular sub-directory is directly dependent on another, though they can be used to build up a system if used in
order. Additionally, some stages, could be skipped entirely. The features they provide could either be
forgone or provided via manual deployments or otherwise. Roughly, the prefixes stage folders correspond to the following
topics:

00 - Baremetal configurations not compatible with Virtual Machine solutions or where it would not make sense

01 - Virtual Machine, Hypervisors and Hyperconverged Infrastructure solutions

02 - Operating System level configs and software

03 - Containerized solutions outside of container orchestration (e.g. Docker, LXC, podman, etc.)

04 - Kubenetes installation including CNI, Ingress, etc.

05 - Kuberetes Deployed Applications

06 - Kubernetes Inception where things get weird and Kubernetes is used to manage Kubernetes. See also 03.

## Status

* 01-proxmox/01-packer is untested and unfinished

* 01/-proxmox/02-terraform creates a VM but does not automate installaton, add an option to simply clone a template that is manually curated

## TODO

[ ] 

[ ] 
