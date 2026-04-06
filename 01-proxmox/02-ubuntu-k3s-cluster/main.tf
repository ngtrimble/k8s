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

  count                         = var.node_count
  proxmox_endpoint              = var.proxmox_endpoint
  proxmox_username              = var.proxmox_username
  proxmox_password              = var.proxmox_password
  proxmox_insecure              = var.proxmox_insecure
  vm_name                       = "${var.vm_name}${count.index + 1}"
  vm_username                   = var.vm_username
  vm_password                   = var.vm_password
  vm_timezone                   = var.vm_timezone
  target_node                   = var.target_node
  cpu_cores                     = var.cpu_cores
  cpu_type                      = var.cpu_type
  memory                        = var.memory
  disk_size                     = var.disk_size
  disk_import_from              = var.disk_import_from
  disk_datastore_id             = var.disk_datastore_id
  network_bridge                = var.network_bridge
  network_address               = var.network_addresses[count.index]
  network_gateway               = var.network_gateway
  network_dns_servers           = var.network_dns_servers
  cloud_image_datastore_id      = var.cloud_image_datastore_id
  ssh_public_key_path           = var.ssh_public_key_path
  vm_os_family                  = var.vm_os_family
  environment_file_datastore_id = var.environment_file_datastore_id
  environment_file_node_name    = var.environment_file_node_name
}
