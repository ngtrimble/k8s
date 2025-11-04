Proxmox VM Terraform module

This module creates or clones a QEMU virtual machine in Proxmox using the Telmate Proxmox provider.

Variables
- `pm_api_url`: API URL (https://proxmox.example:8006/api2/json)
- `pm_user`: User (root@pam)
- `pm_password`: Password (sensitive)
- `target_node`: Node name
- `name`: VM name
- `clone_from`: Template or VM ID to clone
- `full_clone`: Full clone boolean
- `cores`, `sockets`, `memory`, `disk_size`, `storage` etc.

Example usage

module "myvm" {
  source = "./proxmox/terraform/proxmox-vm"

  pm_api_url = "https://proxmox.local:8006/api2/json"
  pm_user = "root@pam"
  pm_password = "REDACTED"
  target_node = "pve01"
  name = "test-vm"
  clone_from = "100"
  full_clone = true
  cores = 2
  memory = 2048
  disk_size = "20G"
  storage = "local-lvm"
  net_bridge = "vmbr0"
  ssh_keys = [file("~/.ssh/id_rsa.pub")]
}

Authentication

You can authenticate to Proxmox either with a username/password (set `pm_user` and `pm_password`) or with an API token. To use an API token, set `pm_user` to the token in the form `username!tokenid@pam` and set `pm_password` to the token secret.

Validation and formatting

If you have Terraform installed you can validate and format the module from the module root:

```sh
terraform fmt
terraform init
terraform validate
```

Notes
- The module uses the Telmate `proxmox` provider. Version ~> 2.9 is recommended but you can adjust in `main.tf`.
- Cloud-init template is provided in `cloud-init.tpl`. If you need more advanced network/cloud-init features, supply a custom ISO or use additional cloud-init config via `user_data`.

Quick start (example)

1. Copy `examples/terraform.tfvars.example` to `examples/terraform.tfvars` and update values.
2. From `proxmox/terraform/examples` run:

```sh
terraform init
terraform apply
```

This will create the VM on the target node using the module defaults unless overridden.
