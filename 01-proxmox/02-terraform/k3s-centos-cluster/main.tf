terraform {
  required_providers {
    proxmox = {
      source = "bpg/proxmox"
      version = ">= 0.98"
    }
  }
}

provider "proxmox" {
  alias = "root-module-proxmox"
  endpoint = var.proxmox_endpoint
  username = var.proxmox_username
  password = var.proxmox_password
  insecure = var.proxmox_insecure
}

module "virtual_machines" {
  source = "../bgp-proxmox"
  providers = {
    proxmox = proxmox.root-module-proxmox
  }

  count = var.node_count  
  proxmox_password = var.proxmox_password
  proxmox_username = var.proxmox_username
  proxmox_endpoint = var.proxmox_endpoint
  proxmox_insecure = var.proxmox_insecure
  cloud_image_url = var.centos_url
}
