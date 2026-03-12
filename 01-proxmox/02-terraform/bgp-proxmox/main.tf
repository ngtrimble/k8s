terraform {
  required_providers {
    proxmox = {
      source = "bpg/proxmox"
      version = ">= 0.98"
    }
  }
}

resource "proxmox_virtual_environment_vm" "vm" {
  name        = var.vm_name
  description = "VM created from cloud image"
  node_name   = var.target_node

  clone {
    vm_id = var.clone_from
  }

  cpu {
    cores = var.cpu_cores
    type  = var.cpu_type
  }

  memory {
    dedicated = var.memory
  }

  disk {
    datastore_id = var.disk_datastore_id
    interface    = "scsi0"
    size         = var.disk_size
  }

  network_device {
    bridge = var.network_bridge
  }

  operating_system {
    type = "l26"
  }

  initialization {
    ip_config {
      ipv4 {
        address = "dhcp"
      }
    }
  }
}

resource "proxmox_virtual_environment_download_file" "cloud_image" {
  content_type = "import"
  datastore_id = var.cloud_image_datastore_id
  node_name    = var.cloud_image_node_name
  url          = var.cloud_image_url
}
