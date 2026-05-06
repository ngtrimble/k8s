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

variable "ssh_key_name" {
  description = "The name of the SSH key snippet to create on Proxmox"
  type        = string
  default     = "proxmox-ssh-key.pub"
}

variable "ssh_key_algorithm" {
  description = "The algorithm to use for the SSH key (e.g. RSA, ED25519)"
  type        = string
  default     = "ED25519"
}

variable "proxmox_node" {
  description = "The Proxmox node where the snippet will be uploaded"
  type        = string
  default     = "pve"
}

variable "proxmox_datastore" {
  description = "The Datastore on Proxmox where the snippet will be uploaded"
  type        = string
  default     = "local"
}

variable "local_key_path" {
  description = "The local directory to save the generated SSH keys to"
  type        = string
  default     = "~/.ssh"
}
