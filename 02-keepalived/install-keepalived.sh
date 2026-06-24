#!/usr/bin/env bash
set -xeu -o pipefail 

if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root" >&2
    exit 1
fi

usage() {
cat << EOF
$0 [-h] [-l LOADBALANCER_IP_MASK]
	
	-h - Help or usage

	-l - Loadbalancer IP address and subnet mask in format IP_ADDRESS/MASK (e.g. 192.168.1.10/24)

	-i - Network interface (e.g. eth0)

	-p - Priority (1-254), higher numbers have higher priority

	-r - Virtual Router ID
EOF
exit 1
}

# These are default args for a k3s configuration that works with MetalLB on bare-metal installations
while getopts "hl:i:p:r:" opt; do
	case $opt in
		h)
		usage
		;;
		l)
		LOADBALANCER_IP_MASK="$OPTARG"
		;;
		p)
		PRIORITY="$OPTARG"
		;;
		i)
		INTERFACE="$OPTARG"
		;;
		r)
		VIRTUAL_ROUTER_ID="$OPTARG"
		;;
		*)
		usage
		;;
	esac
done

if [[ -z "$LOADBALANCER_IP_MASK" ]]; then
	usage
fi

if [[ -z "$PRIORITY" || "$PRIORITY" -lt 1 || "$PRIORITY" -gt 255 ]]; then
	usage
fi

if [[ -z "$INTERFACE" ]]; then
	usage
fi

if [[ -z "$VIRTUAL_ROUTER_ID" || "$VIRTUAL_ROUTER_ID" -lt 1 || "$VIRTUAL_ROUTER_ID" -gt 255 ]]; then
	usage
fi

if [ -r /etc/os-release ]; then
	. /etc/os-release
else
    echo "Cannot determine OS" >&2
    exit 1
fi

case "$ID_LIKE" in
	*debian*)
	OS="debian"
	;;
	*rhel*|*fedora*)
	OS="rhel"
	;;
	*)
	echo "Unsupported OS: $ID" >&2
	exit 1
	;;
esac

if [[ $OS == "debian" ]]; then
	apt update && apt install keepalived netcat-openbsd -y
fi

if [[ $OS == "rhel" ]]; then
	dnf install -y keepalived nmap-ncat
fi

cat << EOF | tee /etc/keepalived/keepalived.conf > /dev/null
vrrp_instance VI_1 {
	interface $INTERFACE 
	virtual_router_id $VIRTUAL_ROUTER_ID
	priority $PRIORITY
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

systemctl enable keepalived
systemctl restart keepalived
