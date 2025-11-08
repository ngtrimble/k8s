packer {
  required_plugins {
    # Uses the Telmate Proxmox packer plugin. Install with `packer init` after adding the plugin to your system.
    proxmox = {
      version = ">= 1.0.0"
      source  = "github.com/Telmate/packer-plugin-proxmox"
    }
  }
}

variable "proxmox_url" {
  type    = string
  default = "https://proxmox.example.local:8006"
}

variable "proxmox_user" {
  type    = string
  default = "root@pam"
}

variable "proxmox_password" {
  type    = string
  default = ""
}

variable "proxmox_node" {
  type    = string
  default = "pve"
}

variable "vm_id" {
  type    = number
  default = 9000
}

variable "template_name" {
  type    = string
  default = "ubuntu-autoinstall-template"
}

variable "storage_pool" {
  type    = string
  default = "local-lvm"
}

variable "iso_file" {
  type    = string
  default = "local:iso/ubuntu-24.04.3-live-server-amd64.iso"
}

variable "iso_storage" {
  type    = string
  default = "local"
}

variable "disk_size" {
  type    = string
  default = "20G"
}

variable "cores" {
  type    = number
  default = 2
}

variable "memory" {
  type    = number
  default = 2048
}

variable "ssh_username" {
  type    = string
  default = "packer"
}

variable "ssh_password" {
  type    = string
  default = "packer"
}

variable "ssh_port" {
  type    = number
  default = 22
}

source "proxmox" "ubuntu-template" {
  proxmox_url      = var.proxmox_url
  username         = var.proxmox_user
  password         = var.proxmox_password
  insecure         = true

  node             = var.proxmox_node
  vm_id            = var.vm_id
  vm_name          = var.template_name

  # Where to put the VM disk
  storage_pool     = var.storage_pool

  # ISO to boot (assumes it's already uploaded to the Proxmox ISO storage)
  iso_file         = var.iso_file
  iso_storage      = var.iso_storage

  # VM resources
  disk_size        = var.disk_size
  cores            = var.cores
  memory           = var.memory

  # SSH (Packer will wait for SSH after the installer finishes)
  ssh_username     = var.ssh_username
  ssh_password     = var.ssh_password
  ssh_port         = var.ssh_port
  ssh_wait_timeout = "20m"

  # Attach a cloud-init seed ISO (created by make-seed.sh) to the VM before boot.
  # This expects the seed ISO to be uploaded to the same storage as `iso_storage`.
  # Set `seed_iso` to the storage path (e.g. "local:iso/seed.iso").
  seed_iso         = "local:iso/seed.iso"

  # Let the plugin convert the VM into a template after provisioning
  convert_to_template = true
  template            = false

  # Other options may be available depending on plugin version.
}

build {
  sources = ["source.proxmox.ubuntu-template"]

  provisioner "shell" {
    inline = [
      "echo 'Provisioner: update and clean up'",
      "sudo apt-get update -y",
      "sudo apt-get upgrade -y",
      "sudo cloud-init clean --logs || true",
      "sudo waagent -deprovision+user -force || true",
      "sudo sync"
    ]
  }
}
