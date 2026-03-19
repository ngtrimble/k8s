variable "proxmox_endpoint" {
  description = "The endpoint URL for the Proxmox API"
  type        = string
  default     = "https://192.168.1.1:8006/"
}

variable "proxmox_username" {
  description = "The username for Proxmox authentication"
  type        = string
  default     = "pveuser"
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

variable "vm_name" {
  description = "Name of the VM"
  type        = string
  default     = "vm-01"
}

variable "vm_username" {
  description = "Username for the VM"
  type        = string
  default     = "pveuser"
}

variable "vm_password" {
  description = "Password for the VM"
  type        = string
  sensitive   = true
}

variable "vm_timezone" {
  description = "Timezone for the VM"
  type        = string
  default     = "UTC"
}

variable "ssh_public_key_path" {
  description = "Path to the SSH public key file"
  type        = string
}

variable "target_node" {
  description = "Proxmox node to deploy VM on"
  type        = string
  default     = "pve"
}

variable "cpu_cores" {
  description = "Number of CPU cores for CentOS VM"
  type        = number
  default     = 2
}

variable "cpu_type" {
  description = "Type of CPU for VM"
  type        = string
  default     = "host"
}

variable "memory" {
  description = "Memory in MB for CentOS VM"
  type        = number
  default     = 4096
}

variable "disk_size" {
  description = "Disk size in GB for VM"
  type        = number
  default     = 40
}

variable "disk_datastore_id" {
  description = "Storage pool for VM disk"
  type        = string
  default     = "local-lvm"
}

variable "network_bridge" {
  description = "Network bridge for VM"
  type        = string
  default     = "vmbr0"
}

variable "network_address" {
  description = "IP address for the VM in CIDR notation (e.g., 192.168.68.100/24)"
  type        = string
  default     = "dhcp"
}

variable "network_gateway" {
  description = "Gateway IP address for the VM"
  type        = string
  default     = ""
}

variable "network_dns_servers" {
  description = "DNS servers to configure on the VM"
  type        = list(string)
  default     = []
}

variable "cloud_image_datastore_id" {
  description = "Storage pool for cloud image"
  type        = string
  default     = "local"
}

variable "cloud_image_node_name" {
  description = "Proxmox node to download the cloud image on"
  type        = string
  default     = "pve"
}

variable "cloud_image_url" {
  description = "URL for the cloud image"
  type        = string
}

variable "cloud_image_file_name" {
  description = "The file name for the cloud image download"
  type        = string
}
