terraform {
  backend "local" {}

  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = ">= 0.98"
    }
    tls = {
      source  = "hashicorp/tls"
      version = ">= 4.2.1"
    }
    local = {
      source  = "hashicorp/local"
      version = ">= 2.8.0"
    }
  }
}
