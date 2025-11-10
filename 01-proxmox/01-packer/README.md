# README.md

## Introduction

Packer is used here to create a Virtual Machine template within your Proxmox installation that can be used to 
clone from. 

## Execution

Run:

```shell
packer build -var 'proxmox_password=PASSWORD_HERE' \
    -var 'node=NODE_NAME_HERE' \
    -var 'proxmox_url=https://HOSTNAME_OR_IP_HERE:8006/api2/json' \
    ubuntu-24-lts-proxmox.pkr.hcl
```
