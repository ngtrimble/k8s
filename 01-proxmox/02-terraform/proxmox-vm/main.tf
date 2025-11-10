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
  scsihw = var.scsihw
  target_node = var.target_node
  boot = "order=virtio0;net0"
  clone = var.clone_from
  full_clone = true
  agent = 1
  onboot = true
  ciuser = var.ciuser
  cipassword = var.cipassword
  ciupgrade = true
  sshkeys = var.sshkeys

  cpu {
    cores = var.cpu_cores
    sockets = var.cpu_sockets
    type = var.cpu_type
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
  }

  network {
    id = 0
    model = var.net_model
    bridge = var.net_bridge
    tag = var.net_vlan
  }
}
