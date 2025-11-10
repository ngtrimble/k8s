# README.md

## Introduction

In order to install Virtual Machines on Proxmox you must first add iso or cloud image files to your Proxmox host. You
can do so manually using the UI. Cloud Image builds of popular Linux distributions are available from Canonical, 
Red Hat, Debian, et. al. These have the advantage of cloud-init integration avoiding loading an installer from
Grub or other bootloader. This can save time as the process of finding exact configurations to load an autoinstall
or kickstart file from an iso with packer is error prone. 

## Cloud Images

This step will create template(s) in your Proxmox environment. 

1. Copy script to your Proxmox host

```shell
scp 01-cloud-images/01-create-templates.sh root@PROXMOX_HOST:~/
```

2. Run script from your Proxmox host

```shell
root@pve-1:~# ./create-templates.sh
```

## Create Virtual Machines

