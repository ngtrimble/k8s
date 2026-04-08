variable "proxmox_endpoint" {
  description = "The endpoint URL for the Proxmox API"
  type        = string
  default     = "https://192.168.1.10:8006/"
}

variable "proxmox_username" {
  description = "The username for Proxmox authentication"
  type        = string
  default     = "root@pam"
}

variable "proxmox_password" {
  description = "The password for Proxmox authentication"
  type        = string
  sensitive   = true
  default     = "password"
}

variable "proxmox_insecure" {
  description = "Whether to skip TLS verification for the Proxmox API"
  type        = bool
  default     = true
}

variable "vm_name" {
  description = "Base name for the VMs to be created"
  type        = string
  default     = "k3s-node"
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

variable "vm_os_family" {
  description = "OS family to determine default admin group (debian or rhel)"
  type        = string
  default     = "rhel"
}

variable "target_node" {
  description = "Proxmox node to deploy VM on"
  type        = string
  default     = "pve"
}

variable "cpu_cores" {
  description = "Number of CPU cores for VM"
  type        = number
  default     = 2
}

variable "cpu_type" {
  description = "Type of CPU for VM"
  type        = string
  default     = "host"
}

variable "memory" {
  description = "Memory in MB for VM"
  type        = number
  default     = 4096
}

variable "disk_size" {
  description = "Disk size in GB for VM"
  type        = number
  default     = 40
}

variable "disk_import_from" {
  description = "Path to the disk image to import from"
  type        = string
}

variable "storage" {
  description = "Storage pool for VM"
  type        = string
  default     = "local-lvm"
}

variable "network_bridge_1" {
  description = "First network bridge for VM"
  type        = string
  default     = "vmbr0"
}

variable "network_bridge_2" {
  description = "Second network bridge for VM"
  type        = string
  default     = "vmbr1"
}

variable "network_addresses_1" {
  description = "IP addresses for the VM's in CIDR notation (e.g., 192.168.68.100/24)"
  type        = list(string)
  default     = ["dhcp"]
}

variable "network_addresses_2" {
  description = "IP addresses for the VM's in CIDR notation (e.g., 192.168.68.100/24)"
  type        = list(string)
  default     = []
}

variable "network_gateway" {
  description = "Gateway IP address for the VM"
  type        = string
  default     = null
}

variable "network_dns_servers" {
  description = "DNS servers to configure on the VM"
  type        = list(string)
  default     = []
}

variable "disk_datastore_id" {
  description = "Storage pool for data"
  type        = string
  default     = "local-lvm"
}

variable "cloud_image_node_name" {
  description = "Proxmox node to download cloud image on"
  type        = string
  default     = "pve"
}

variable "node_count" {
  description = "Number of nodes to create"
  type        = number
  default     = 1
}

variable "cloud_image_datastore_id" {
  description = "Storage pool for cloud image"
  type        = string
  default     = "local"
}

variable "cloud_image_file_name" {
  description = "The file name of the cloud image"
  type        = string
}

variable "ssh_public_key_path" {
  description = "Path to the SSH public key file"
  type        = string
}

variable "environment_file_datastore_id" {
  description = "Storage pool for environment file (cloud-config)"
  type        = string
  default     = "local"
}

variable "environment_file_node_name" {
  description = "Proxmox node to store environment file on"
  type        = string
  default     = "pve"
}

