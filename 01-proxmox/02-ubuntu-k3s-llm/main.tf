terraform {
  backend "local" {
  }

  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = ">= 0.103.0"
    }
  }
}

provider "proxmox" {
  alias    = "root-module-proxmox"
  endpoint = var.proxmox_endpoint
  username = var.proxmox_username
  password = var.proxmox_password
  insecure = var.proxmox_insecure
}

locals {
  cloud_config = <<-EOF
  #cloud-config
  # The '.' at the end of the fqdn is required. If it's not included, cloud-init will fail to set the hostname 
  # and the VM will end up with a default hostname like 'localhost'.
  fqdn: ${var.vm_name}.
  timezone: ${var.vm_timezone}
  users:
    - default
    - name: ${var.vm_username}
      sudo: ALL=(ALL) NOPASSWD:ALL
      ssh_authorized_keys:
        - ${trimspace(data.local_file.ssh_public_key.content)}
      shell: /bin/bash
  package_update: true
  package_upgrade: true
  packages:
    - qemu-guest-agent
    - vim
  runcmd:
    - ufw disable
    - systemctl enable qemu-guest-agent
    - systemctl start qemu-guest-agent
  power_state:
    delay: now
    mode: reboot
    message: "Rebooting after package updates"
    timeout: 30
    condition: true
  EOF
}

data "local_file" "ssh_public_key" {
  filename = var.ssh_public_key_path
}

module "virtual_machines" {
  source = "../virtual-machine"
  providers = {
    proxmox = proxmox.root-module-proxmox
  }

  count                         = var.node_count
  proxmox_endpoint              = var.proxmox_endpoint
  proxmox_username              = var.proxmox_username
  proxmox_password              = var.proxmox_password
  proxmox_insecure              = var.proxmox_insecure
  vm_name                       = "${var.vm_name}${count.index + 1}"
  target_node                   = var.target_node
  cpu_cores                     = var.cpu_cores
  cpu_type                      = var.cpu_type
  memory                        = var.memory
  disk_size                     = var.disk_size
  disk_import_from              = var.disk_import_from
  disk_datastore_id             = var.disk_datastore_id
  network_bridge_1              = var.network_bridge_1
  network_address_1             = var.network_addresses_1[count.index]
  network_gateway               = var.network_gateway
  network_dns_servers           = var.network_dns_servers
  cloud_image_datastore_id      = var.cloud_image_datastore_id
  environment_file_datastore_id = var.environment_file_datastore_id
  environment_file_node_name    = var.environment_file_node_name
  cloud_config                  = local.cloud_config
}
