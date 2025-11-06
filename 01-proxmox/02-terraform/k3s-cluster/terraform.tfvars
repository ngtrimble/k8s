pm_api_url = "https://192.168.68.11:8006/api2/json"
pm_user = "root@pam"
pm_password = "abcd1234"
name = "k3s-node"
node_count = 7
# target_node is required unless proxmox is set up with a cluster. Since this is
# a homelab of just one computer, we keep it simple.
target_node = "obsidian"
# iso and clone_from are mutually exclusive
#iso = "local:iso/ubuntu-24.04.3-live-server-amd64.iso"
clone_from = "ubuntu-24-lts"
clone_id = 102