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

variable "cores" {
  type = number
  default = 2
}

variable "sockets" {
  type = number
  default = 1
}

variable "memory" {
  type = number
  default = 2048
}

variable "scsihw" {
  type = string
  default = "virtio-scsi-pci"
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

variable "storage_type" {
  type = string
  default = "lvm"
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

variable "cloudinit" {
  description = "Enable simple cloud-init configuration"
  type = bool
  default = true
}

variable "cloudinit_user" {
  type = string
  default = "ubuntu"
}

variable "cloudinit_password" {
  type = string
  sensitive = true
  default = ""
}

variable "cloudinit_ipconfig0" {
  type = string
  default = ""
}

variable "cloudinit_searchdomain" {
  type = string
  default = ""
}

variable "cloudinit_nameserver" {
  type = string
  default = ""
}

variable "iso" {
  type = string
  default = ""
}

variable "cpu_type" {
  type = string
  default = "host"
  description = "Sets the CPU type for this VM. The default is host as it is the most perfomant, although least compatible in more complex environments."
}
