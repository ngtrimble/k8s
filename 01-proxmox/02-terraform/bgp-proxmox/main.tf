terraform {
  required_providers {
    proxmox = {
      source = "bpg/proxmox"
      version = ">= 0.98"
    }
  }
}

provider "proxmox" {
  endpoint = var.proxmox_endpoint
  username = var.proxmox_username
  password = var.proxmox_password
  insecure = var.proxmox_insecure
}

# CentOS 10 VM created from cloud image
resource "proxmox_virtual_environment_vm" "centos_vm" {
  name        = var.centos_vm_name
  description = "CentOS 10 VM created from cloud image"
  node_name   = var.centos_target_node
  vm_id       = var.centos_vm_id

  clone {
    vm_id = var.centos_clone_from
  }

  cpu {
    cores = var.centos_cores
    type  = "host"
  }

  memory {
    dedicated = var.centos_memory
  }

  disk {
    datastore_id = var.centos_storage
    interface    = "scsi0"
    size         = var.centos_disk_size
  }

  network_device {
    bridge = var.centos_bridge
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

  lifecycle {
    ignore_changes = [initialization]
  }

  depends_on = []
}

resource "proxmox_virtual_environment_download_file" "centos_cloud_image" {
  content_type = "import"
  datastore_id = var.data_storage_id
  node_name    = var.cloud_image_node_name
  url          = var.centos_url
}