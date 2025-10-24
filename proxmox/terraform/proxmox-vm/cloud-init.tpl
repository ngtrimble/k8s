#cloud-config
package_update: true
packages:
  - qemu-guest-agent
users:
  - name: ${user}
    sudo: ALL=(ALL) NOPASSWD:ALL
    lock_passwd: false
    passwd: ${password}
ssh_authorized_keys:
%{ for key in ssh_keys }
  - ${key}
%{ endfor }

hostname: ${hostname}
manage_etc_hosts: true

runcmd:
  - [ systemctl, enable, --now, qemu-guest-agent ]
