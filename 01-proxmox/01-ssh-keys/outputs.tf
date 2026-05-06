output "private_key_openssh" {
  description = "The generated private key in OpenSSH format"
  value       = tls_private_key.this.private_key_openssh
  sensitive   = true
}

output "public_key_openssh" {
  description = "The generated public key in OpenSSH format"
  value       = tls_private_key.this.public_key_openssh
}

output "proxmox_snippet_id" {
  description = "The ID of the uploaded snippet file in Proxmox"
  value       = proxmox_virtual_environment_file.ssh_key_snippet.id
}

output "local_private_key_path" {
  description = "The path where the private key was saved locally"
  value       = local_sensitive_file.private_key.filename
}
