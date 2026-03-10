#!/usr/bin/env bash
set -eo pipefail

usage() {
	echo "$0 HOSTNAME IP GATEWAY DNS IFACE"
	exit 1
}

if [ -z "$1" ]
then
	usage
fi

if [ -z "$2" ]
then
	usage
fi

if [ -z "$3" ]
then
	usage
fi

if [ -z "$4" ]
then
	usage
fi

if [ -z "$5" ]
then
	usage
fi

HOSTNAME=$1
IP=$2
GATEWAY=$3
DNS=$4
IFACE=$5

hostnamectl set-hostname $HOSTNAME
nmcli connection modify $IFACE ipv4.addresses $IP
nmcli connection modify $IFACE ipv4.gateway $GATEWAY 
nmcli connection modify $IFACE ipv4.dns $DNS
nmcli connection modify $IFACE ipv4.method manual
nmcli device show $IFACE

echo "Reboot for changes to take effect..."
