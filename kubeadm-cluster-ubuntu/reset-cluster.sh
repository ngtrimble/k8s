#!/usr/bin/env bash
set -e

if [[ $EUID -ne 0 ]]; then
        echo "This script must be run as root."
        exit 1
fi

kubeadm reset -f
rm -rf /etc/cni/net.d
