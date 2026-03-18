terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = ">= 0.98"
    }
  }
}

resource "proxmox_virtual_environment_vm" "vm" {
  name      = var.vm_name
  node_name = var.target_node

  cpu {
    cores = var.cpu_cores
    type  = var.cpu_type
  }

  memory {
    dedicated = var.memory
  }

  disk {
    interface    = "scsi0"
    datastore_id = var.disk_datastore_id
    size         = var.disk_size
    import_from  = proxmox_virtual_environment_download_file.cloud_image.id
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
        address = var.network_address
        gateway = var.network_address != "auto" && var.network_address != "slaac" ? var.network_gateway : null
      }

    }

    dns {
      servers = var.network_dns_servers
    }
  }

  agent {
    # read 'Qemu guest agent' section, change to true only when ready
    enabled = false
  }
}

resource "proxmox_virtual_environment_download_file" "cloud_image" {
  content_type = "import"
  datastore_id = var.cloud_image_datastore_id
  node_name    = var.cloud_image_node_name
  url          = var.cloud_image_url
  file_name    = var.cloud_image_file_name
}
