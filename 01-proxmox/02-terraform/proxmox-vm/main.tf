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
  # scsihw = "virtio-scsi-single"
  target_node = var.target_node
  #boot = "scsi0,ide2,net0"
  #clone = var.clone_from
  clone_id = var.clone_id
  full_clone = true
  agent = 1
  
  # cpu {
  #   cores = var.cores
  #   sockets = var.sockets
  #   type = var.cpu_type
  # }

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

  #sshkeys = var.sshkeys

  # cloudinit = var.cloudinit ? {
  #   user = var.cloudinit_user
  #   password = var.cloudinit_password
  #   ipconfig0 = var.cloudinit_ipconfig0
  #   # searchdomain = var.cloudinit_searchdomain
  #   # nameserver = var.cloudinit_nameserver
  #   # dns = var.cloudinit_nameserver
  # } : null


  # lifecycle {
  #   ignore_changes = [sshkeys]
  # }
}
