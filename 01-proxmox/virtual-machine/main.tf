terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = ">= 0.103.0"
    }
  }
}

resource "proxmox_virtual_environment_vm" "vm" {
  name            = var.vm_name
  node_name       = var.target_node
  stop_on_destroy = true

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
    import_from  = var.disk_import_from
  }

  operating_system {
    type = "l26"
  }

  network_device {
    bridge = var.network_bridge_1
  }

  network_device {
    bridge = var.network_bridge_2

  }

  initialization {
    # ip_config for the first network_device (vmbr0)
    ip_config {
      ipv4 {
        address = var.network_address_1
        gateway = var.network_address_1 != "dhcp" ? var.network_gateway : null
      }
    }

    # ip_config for the second network_device (vmbr1)
    ip_config {
      ipv4 {
        address = var.network_address_2
      }
    }

    dns {
      servers = var.network_dns_servers
    }

    user_data_file_id = proxmox_virtual_environment_file.user_data_cloud_config.id
  }

  agent {
    enabled = true
  }
}

resource "proxmox_virtual_environment_file" "user_data_cloud_config" {
  content_type = "snippets"
  datastore_id = var.environment_file_datastore_id
  node_name    = var.environment_file_node_name

  source_raw {
    data = var.cloud_config

    file_name = "${var.vm_name}-user-data-cloud-config.yaml"
  }
}
