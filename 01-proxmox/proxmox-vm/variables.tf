variable "target_node" {
  description = "Proxmox node name to create VM on"
  type = string
  default = null
}

variable "name" {
  description = "Name of the VM"
  type = string
}

variable "clone_from" {
  description = "VM/template to clone from"
  type = string
  default = ""
}

variable "cpu_cores" {
  type = number
  default = 2
}

variable "cpu_sockets" {
  type = number
  default = 1
}

variable "cpu_type" {
  type = string
  default = "host"
}

variable "memory" {
  type = number
  default = 4096
}

variable "scsihw" {
  type = string
  default = "virtio-scsi-single"
}

variable "disk_size" {
  description = "Disk size in GiB"
  type = string
  default = "16G"
}

variable "disk_type" {
  type = string
  default = "scsi"
}

variable "storage" {
  type = string
  default = "local-lvm"
}

variable "disk_iothread" {
  type = bool
  default = false
}

variable "net_model" {
  type = string
  default = "virtio"
}

variable "net_bridge" {
  type = string
  default = "vmbr0"
}

variable "net_vlan" {
  type = number
  default = 0
}

variable "sshkeys" {
  type = string
  default = ""
}

variable "ciuser" {
  type = string
  default = "pve-user"
}

variable "cipassword" {
  type = string
  sensitive = true
  default = "changeme"
}
