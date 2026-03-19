terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = ">= 0.98"
    }
  }
}

provider "proxmox" {
  alias    = "root-module-proxmox"
  endpoint = var.proxmox_endpoint
  username = var.proxmox_username
  password = var.proxmox_password
  insecure = var.proxmox_insecure
}

module "virtual_machines" {
  source = "../virtual-machine"
  providers = {
    proxmox = proxmox.root-module-proxmox
  }

  count                    = var.node_count
  proxmox_endpoint         = var.proxmox_endpoint
  proxmox_username         = var.proxmox_username
  proxmox_password         = var.proxmox_password
  proxmox_insecure         = var.proxmox_insecure
  vm_name                  = "${var.vm_name}${count.index}"
  vm_username              = var.vm_username
  vm_password              = var.vm_password
  vm_timezone              = var.vm_timezone
  target_node              = var.target_node
  cpu_cores                = var.cpu_cores
  cpu_type                 = var.cpu_type
  memory                   = var.memory
  disk_size                = var.disk_size
  disk_datastore_id        = var.disk_datastore_id
  network_bridge           = var.network_bridge
  network_address          = var.network_address
  network_gateway          = var.network_gateway
  cloud_image_datastore_id = var.cloud_image_datastore_id
  cloud_image_node_name    = var.cloud_image_node_name
  cloud_image_url          = var.cloud_image_url
  cloud_image_file_name    = var.cloud_image_file_name
}
