output "vm_id" {
  value = proxmox_vm_qemu.vm.id
}

output "vm_qemu_id" {
  value = proxmox_vm_qemu.vm.qemu_os
}

output "vm_name" {
  value = proxmox_vm_qemu.vm.name
}
