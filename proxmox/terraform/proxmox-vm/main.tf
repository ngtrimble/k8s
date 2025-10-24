terraform {
  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = "3.0.2-rc05"
    }
  }
}

resource "proxmox_vm_qemu" "vm" {
  name   = var.name
  memory = var.memory
  scsihw = "virtio-scsi-single"
  target_node = var.target_node
  boot = "order=scsi0;ide2"
  
  cpu {
    cores = var.cores
    sockets = var.sockets
  }

  disks {
    scsi {
      scsi0 {
        disk {
          size = var.disk_size
          storage = var.storage
          iothread = var.disk_iothread
        }
      }
    }
    ide {
      ide2 {
        cdrom {
          iso = var.iso
        }
      }
    }
  }

  network {
    id = 0
    model = var.net_model
    bridge = var.net_bridge
    tag = var.net_vlan
  }

  sshkeys = var.sshkeys

  # cloudinit = var.cloudinit ? {
  #   user = var.cloudinit_user
  #   password = var.cloudinit_password
  #   ipconfig0 = var.cloudinit_ipconfig0
  #   searchdomain = var.cloudinit_searchdomain
  #   nameserver = var.cloudinit_nameserver
  #   dns = var.cloudinit_nameserver
  # } : null

  lifecycle {
    ignore_changes = [sshkeys]
  }
}
