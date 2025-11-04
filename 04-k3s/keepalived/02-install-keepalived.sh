#!/usr/bin/env bash
set -e -o pipefail 

usage() {
cat << EOF
$0 [-h] [-l LOADBALANCER_IP_MASK]
	
	-h - Help or usage

	-l - Loadbalancer IP address and subnet mask in format IP_ADDRESS/MASK (e.g. 192.168.1.10/24)
EOF
exit 1
}

# These are default args for a k3s configuration that works with MetalLB on bare-metal installations
while getopts "hl:" opt; do
	case $opt in
		h)
		usage
		;;
		l)
		LOADBALANCER_IP_MASK="$OPTARG"
		;;
		*)
		usage
		;;
	esac
done

if [[ -z "$LOADBALANCER_IP_MASK" ]]; then
	usage
fi

sudo apt update && sudo apt install keepalived -y

cat << EOF | sudo tee /etc/default/keepalived
# Options to pass to keepalived

# DAEMON_ARGS are appended to the keepalived command-line
DAEMON_ARGS="-l -D --dont-fork"
EOF

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
	     $LOADBALANCER_IP_MASK 
	}
}
EOF

sudo systemctl enable keepalived
sudo systemctl restart keepalived
