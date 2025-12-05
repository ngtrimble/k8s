# README.md

## Introduction

This is non-functional as of 12/5/2025. Creating a template from an ISO is error prone with Ubuntu and Proxmox when
attempting to install and configure cloud-init. Using the Ubuntu Cloud Images still requires creating an intial VM
via a script anyway, so 01-cloud-images accomplishes this now. Packer is used here to create a Virtual Machine 
template within your Proxmox installation that can be used to clone from.

## Execution

Run:

```shell
packer build -var 'proxmox_password=PASSWORD_HERE' \
    -var 'node=NODE_NAME_HERE' \
    -var 'proxmox_url=https://HOSTNAME_OR_IP_HERE:8006/api2/json' \
    ubuntu-24-lts-proxmox.pkr.hcl
```
