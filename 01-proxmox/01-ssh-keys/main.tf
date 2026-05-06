terraform {
  backend "local" {
  }

  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = ">= 0.98"
    }
  }
}

provider "proxmox" {
  endpoint = var.proxmox_endpoint
  username = var.proxmox_username
  password = var.proxmox_password
  insecure = var.proxmox_insecure
}

# Generate an SSH key
resource "tls_private_key" "this" {
  algorithm = var.ssh_key_algorithm
}

# Save the private key locally
resource "local_sensitive_file" "private_key" {
  content         = tls_private_key.this.private_key_openssh
  filename        = pathexpand("${var.local_key_path}/${var.ssh_key_name}")
  file_permission = "0600"
}

# Save the public key locally
resource "local_file" "public_key" {
  content         = tls_private_key.this.public_key_openssh
  filename        = pathexpand("${var.local_key_path}/${var.ssh_key_name}.pub")
  file_permission = "0644"
}

# Upload the public key as a Snippet to Proxmox
resource "proxmox_virtual_environment_file" "ssh_key_snippet" {
  content_type = "snippets"
  datastore_id = var.proxmox_datastore
  node_name    = var.proxmox_node
  
  source_raw {
    data      = tls_private_key.this.public_key_openssh
    file_name = var.ssh_key_name
  }
}
