#!/usr/bin/env bash
set -ex -o pipefail

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
    # Feel free to change any of these to your liking
    qm create $1 --name $2 --ostype l26 

    # Set networking to default bridge
    qm set $1 --net0 virtio,bridge=vmbr0

    # Set display to serial
    qm set $1 --serial0 socket --vga serial0

    # Set memory, cpu, type defaults
    # If you are in a cluster, you might need to change cpu type
    qm set $1 --memory 2048 --cores 2 --cpu host

    # Set boot device to new file
    qm set $1 --scsi0 ${storage}:0,import-from="$(pwd)/$3",discard=on

    # Set scsi hardware as default boot disk using virtio scsi single
    qm set $1 --boot order=scsi0 --scsihw virtio-scsi-single

    # Enable Qemu guest agent in case the guest has it available
    qm set $1 --agent enabled=1,fstrim_cloned_disks=1

    # Add cloud-init device
    qm set $1 --ide2 ${storage}:cloudinit

    # Set CI ip config
    # IP6 = auto means SLAAC (a reliable default with no bad effects on non-IPv6 networks)
    # IP = DHCP means what it says, so leave that out entirely on non-IPv4 networks to avoid DHCP delays
    qm set $1 --ipconfig0 "ip6=auto,ip=dhcp"

    # Add the user
    qm set $1 --ciuser ${username}
    # Set the password
    qm set $1 --cipassword ${password} 
 
    # Resize the disk to 8G, a reasonable minimum. You can expand it more later.
    # If the disk is already bigger than 8G, this will fail, and that is okay.
    qm disk resize $1 scsi0 8G

    # Make it a template
    qm template $1

    # Remove file when done
    rm $3
}

#Username to create on VM template
export username=pve-user

#Password to use for pve-user
export password=changeme

#Name of your storage
export storage=local-lvm

# Ubuntu 24.04 (Noble Numbat) LTS
wget "https://cloud-images.ubuntu.com/releases/24.04/release/ubuntu-24.04-server-cloudimg-amd64.img"
create_template 1000 "ubuntu-24-lts-cloudimg-template" "ubuntu-24.04-server-cloudimg-amd64.img"
