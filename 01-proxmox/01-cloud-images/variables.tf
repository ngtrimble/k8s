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

variable "cloud_images" {
  description = "List of cloud images to download"
  type = list(object({
    content_type = optional(string, "import")
    datastore_id = string
    node_name    = string
    url          = string
    file_name    = string
    overwrite    = optional(bool, false)
  }))
  default = []
}

