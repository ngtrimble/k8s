#!/usr/bin/env bash
set -e -o pipefail

# Credit to https://www.apalrd.net/posts/2023/pve_cloud/ for initial script

# Create template
# args:
# vm_id
# vm_name
# file name in the current directory
function create_template() {
    # Print all of the configuration
    echo "Creating template $2 ($1)"

    # Create new VM 
    qm create $1 --name $2 --ostype l26

    # Set networking to default bridge
    qm set $1 --net0 virtio,bridge=vmbr0

    # Set display to serial
    qm set $1 --serial0 socket --vga serial0

    # Set memory, cpu, type defaults
    # If you are in a cluster, you might need to change cpu type
    qm set $1 --memory 4096 --cores 2 --cpu host

    # Create drive and import downloaded image to volume
    qm set $1 --scsi0 ${disk_storage}:0,import-from="$(pwd)/$3",discard=on

    # Set scsi hardware as default boot disk using virtio-scsi-single
    qm set $1 --boot "order=scsi0;net0" --scsihw virtio-scsi-single

    # Enable Qemu guest agent in case the guest has it available
    qm set $1 --agent enabled=1,fstrim_cloned_disks=1

    # Add cloud-init device
    qm set $1 --cdrom ${disk_storage}:cloudinit

    # Set CI ip config
    # IP6 = auto means SLAAC (a reliable default with no bad effects on non-IPv6 networks)
    # IP = DHCP means what it says, so leave that out entirely on non-IPv4 networks to avoid DHCP delays
    qm set $1 --ipconfig0 "ip=dhcp,ip6=auto"

    # Add the user
    qm set $1 --ciuser ${ciuser}
    # Set the password
    qm set $1 --cipassword ${cipassword}
    # Set the sshkeys for login
    qm set $1 --sshkeys ${sshkeys}
    # # TODO - this refuses to take. Attempts to use this feature are being abandoned as of 11/24/2025
    # # Set cicustom
    # qm set $1 --cicustom ${cicustom}
 
    # Resize the disk to 8G, a reasonable minimum. You can expand it more later.
    # If the disk is already bigger than 8G, this will fail, and that is okay.
    qm disk resize $1 scsi0 8G

    qm start $1

    #qm shutdown $1

    # Make it a template
    #qm template $1
}

# Set content type local so that snippets can be used
pvesm set local --content iso,backup,vztmpl,snippets,images,rootdir,import

# Create an ssh key pair if it does not already exist
# You can modifiy or omit this if you prefer to supply and store your key in another manner.
export pve_key_filename="/root/.ssh/pve-key.pub"
if [[ ! -f $pve_key_filename ]]; then
    mkdir -p /root/.ssh
    ssh-keygen -f /root/.ssh/pve-key -N ""
fi
#pve_key=$(head -n 1 ~/.ssh/pve-key.pub | tr -d '\n')
export sshkeys=$pve_key_filename

# Name of your disk_storage
export disk_storage=local-lvm

# # Username to create on VM template
export ciuser=pve-user

# Password to use for pve-user
export cipassword=changeme

# # TODO - this refuses to take. Attempts to use this feature are being abandoned as of 11/24/2025
# # Cloud Init custom snippet for Proxmox / Qemu support
# # See https://registry.terraform.io/providers/Telmate/proxmox/latest/docs/guides/cloud-init%2520getting%2520started#creating-a-snippet
# mkdir -p /var/lib/vz/snippets
# tee /var/lib/vz/snippets/userdata.yaml << EOF
# #cloud-config
# hostname: ubuntu-24-lts-cloudimg-template
# manage_etc_hosts: true
# fqdn: ubuntu-24-lts-cloudimg-template
# user: pve-user
# password: $5$XjvKEvrR$8FursN9.LHS.0IJUft5xLba2WTKZqkBSRNpGtfQ.5H.
# ssh_authorized_keys:
#   - ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJPP/lSyl+XTftpUdAA31KqGL6edLnAQSB2GS3sr8WRp root@obsidian
# chpasswd:
#   expire: False
# users:
#   - default
# package_upgrade: false
# packages:
#   - qemu-guest-agent
# runcmd:
#   - systemctl enable qemu-guest-agent
#   - systemctl start qemu-guest-agent
# EOF
# export cicustom="user=local:snippets/userdata.yaml"

# Ubuntu 24.04 (Noble Numbat) LTS
curl -skL -O -C - "https://cloud-images.ubuntu.com/releases/24.04/release/ubuntu-24.04-server-cloudimg-amd64.img"
create_template 1000 "ubuntu-24-lts-cloudimg-template" "ubuntu-24.04-server-cloudimg-amd64.img"

printf "VM 1000 starting up. Log into VM and run:\n\n\t"
printf "sudo apt-get install -y qemu-guest-agent && sudo systemctl enable qemu-guest-agent && sudo systemctl start qemu-guest-agent && sudo apt install -y avahi-daemon && sudo shutdown -h now\n"
printf "Next make VM 1000 a template via the Proxmox UI or by issuing command: qm template 1000\n"
