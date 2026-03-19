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

    user_data_file_id = proxmox_virtual_environment_file.user_data_cloud_config.id
  }

  agent {
    enabled = true
  }
}

resource "proxmox_virtual_environment_download_file" "cloud_image" {
  content_type = "import"
  datastore_id = var.cloud_image_datastore_id
  node_name    = var.cloud_image_node_name
  url          = var.cloud_image_url
  file_name    = var.cloud_image_file_name
  overwrite    = false
}

resource "proxmox_virtual_environment_file" "user_data_cloud_config" {
  content_type = "snippets"
  datastore_id = var.cloud_image_datastore_id
  node_name    = var.cloud_image_node_name

  source_raw {
    data = <<-EOF
    #cloud-config
    hostname: ${var.vm_name}
    timezone: ${var.vm_timezone}
    users:
      - default
      - name: ${var.vm_username}
        groups:
          - wheel
          - sudo
        sudo: ALL=(ALL) NOPASSWD:ALL
    package_update: true
    packages:
      - qemu-guest-agent
    runcmd:
      - systemctl enable qemu-guest-agent
      - systemctl start qemu-guest-agent
      - echo "done" > /tmp/cloud-config.done
    EOF

    file_name = "user-data-cloud-config.yaml"
  }
}