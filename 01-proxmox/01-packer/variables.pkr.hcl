# Optional overrides for `packer build` - keep sensitive values out of this file in CI
variable "proxmox_url" { default = "https://proxmox.local:8006" }
variable "proxmox_user" { default = "root@pam" }
# Don't commit real credentials here; use env vars or pass with -var
variable "proxmox_password" { default = "" }
variable "proxmox_node" { default = "pve" }
variable "vm_id" { default = 9000 }
variable "template_name" { default = "ubuntu-autoinstall-template" }
variable "storage_pool" { default = "local-lvm" }
variable "iso_file" { default = "local:iso/ubuntu-22.04-live-server-amd64.iso" }
variable "iso_storage" { default = "local" }
variable "disk_size" { default = "20G" }
variable "cores" { default = 2 }
variable "memory" { default = 2048 }
variable "ssh_username" { default = "ubuntu" }
variable "ssh_password" { default = "ubuntu" }
variable "ssh_port" { default = 22 }
