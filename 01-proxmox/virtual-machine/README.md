# BGP Proxmox Terraform Configuration

This Terraform configuration sets up the Proxmox provider for managing Proxmox resources via BGP (Border Gateway Protocol) configurations.

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) installed (version 1.0+ recommended)
- Access to a Proxmox VE server
- Proxmox API credentials (username and password)

## Setup

1. **Clone or navigate to this directory**:
   ```bash
   cd /path/to/your/k8s/01-proxmox/02-terraform/bgp-proxmox
   ```

2. **Configure your credentials**:
   Edit `terraform.tfvars` and replace the placeholder values:
   ```hcl
   proxmox_endpoint = "https://your-proxmox-server:8006/"
   proxmox_username = "your-actual-username"
   proxmox_password = "your-actual-password"
   proxmox_insecure = true  # Set to false if using valid SSL certificates
   ```

## Variables

| Variable | Description | Type | Default | Required |
|----------|-------------|------|---------|----------|
| `proxmox_endpoint` | Proxmox API endpoint URL | string | `https://192.168.68.11:8006/` | No |
| `proxmox_username` | Proxmox username for authentication | string | - | Yes |
| `proxmox_password` | Proxmox password for authentication | string | - | Yes |
| `proxmox_insecure` | Skip TLS verification (useful for self-signed certificates) | bool | `true` | No |

## Usage

1. **Initialize Terraform**:
   ```bash
   terraform init
   ```

2. **Plan the deployment**:
   ```bash
   terraform plan -var-file=terraform.tfvars
   ```

3. **Apply the configuration**:
   ```bash
   terraform apply -var-file=terraform.tfvars
   ```

4. **Confirm** with `yes` when prompted.

## Security Notes

- The `proxmox_password` variable is marked as sensitive and won't be displayed in logs
- Consider using environment variables or Terraform Cloud/Enterprise for production deployments
- For enhanced security, set `proxmox_insecure = false` and use proper SSL certificates

## Troubleshooting

- Ensure your Proxmox user has appropriate permissions for API access
- Verify the endpoint URL is correct and accessible
- Check that the Proxmox API is enabled in your Proxmox installation

## Next Steps

This configuration provides the foundation for BGP-related Proxmox resources. Add your BGP configuration resources to `main.tf` as needed.