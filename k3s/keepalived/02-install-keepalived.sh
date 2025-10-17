#!/usr/bin/env bash
set -e -o pipefail 

usage() {
cat << EOF
$0 [-h]

	-h - Help or usage
EOF
exit 1
}

# These are default args for a k3s configuration that works with MetalLB on bare-metal installations
while getopts "hl:" opt; do
	case $opt in
		h)
		usage
		;;
		*)
		usage
		;;
	esac
done

sudo apt update && sudo apt install keepalived -y

cat << EOF | sudo tee /etc/sysctl.d/99-ipv4-ip-forward.conf > /dev/null
# Needed for keepalived
# Added by $0
 
net.ipv4.ip_forward = 1
net.ipv4.ip_nonlocal_bind = 1
EOF
sudo service procps force-reload

cat << EOF | sudo tee /etc/keepalived/keepalived.conf > /dev/null
vrrp_instance VI_1 {
	state MASTER
	interface ens18 
	virtual_router_id 51
	priority 255
	advert_int 1
	authentication {
	      auth_type PASS
	      auth_pass 12345
	}
	virtual_ipaddress {
	      192.168.68.21/22
	}
}
EOF

sudo systemctl stop keepalived
sudo systemctl start keepalived
sudo systemctl enable keepalived
