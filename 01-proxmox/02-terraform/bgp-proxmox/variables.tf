variable "proxmox_endpoint" {
  description = "The endpoint URL for the Proxmox API"
  type        = string
  default     = "https://192.168.68.11:8006/"
}

variable "proxmox_username" {
  description = "The username for Proxmox authentication"
  type        = string
}

variable "proxmox_password" {
  description = "The password for Proxmox authentication"
  type        = string
  sensitive   = true
}

variable "proxmox_insecure" {
  description = "Whether to skip TLS verification for the Proxmox API"
  type        = bool
  default     = true
}

variable "centos_vm_name" {
  description = "Name of the CentOS 10 VM"
  type        = string
  default     = "centos10-vm"
}

variable "centos_target_node" {
  description = "Proxmox node to deploy CentOS 10 VM on"
  type        = string
  default     = "pve"
}

variable "centos_vm_id" {
  description = "VM ID for CentOS 10 VM"
  type        = number
  default     = 100
}

variable "centos_clone_from" {
  description = "CentOS 10 cloud image template name to clone from"
  type        = string
  default     = "centos-10"
}

variable "centos_cores" {
  description = "Number of CPU cores for CentOS VM"
  type        = number
  default     = 2
}

variable "centos_memory" {
  description = "Memory in MB for CentOS VM"
  type        = number
  default     = 4096
}

variable "centos_disk_size" {
  description = "Disk size in GB for CentOS VM"
  type        = number
  default     = 40
}

variable "centos_storage" {
  description = "Storage pool for CentOS VM"
  type        = string
  default     = "local-lvm"
}

variable "centos_bridge" {
  description = "Network bridge for CentOS VM"
  type        = string
  default     = "vmbr0"
}

variable "data_storage_id" {
  description = "Storage pool for data"
  type        = string
  default     = "local"
}

variable "cloud_image_node_name" {
  description = "Proxmox node to download CentOS cloud image on"
  type        = string
  default     = "pve"
}

variable "centos_url" {
  description = "URL for the CentOS 10 cloud image"
  type        = string
  default     = "https://cloud.centos.org/centos/10-stream/x86_64/images/CentOS-Stream-GenericCloud-10-latest.x86_64.qcow2"
}