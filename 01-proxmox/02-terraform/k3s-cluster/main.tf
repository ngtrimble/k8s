terraform {
  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = "3.0.2-rc05"
    }
  }
}

provider "proxmox" {
  alias = "root-module-proxmox"
  pm_api_url = var.pm_api_url
  pm_user    = var.pm_user
  pm_password = var.pm_password
  pm_tls_insecure = var.pm_tls_insecure
}

module "vm" {
  source = "../proxmox-vm"
  providers = {
    proxmox = proxmox.root-module-proxmox
  }
  
  count = var.node_count
  name = "${var.name}-${count.index}"
  cpu_cores = var.cpu_cores
  memory = var.memory
  disk_size = var.disk_size
  clone_from = var.clone_from
  target_node = var.target_node
}
