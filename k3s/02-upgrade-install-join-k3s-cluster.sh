#!/usr/bin/env bash
set -e

usage() {
	echo "Usage: $0 K3S_TOKEN K3S_SERVER"
	exit 1
}


if [[ -z "$1" ]]; then
	usage
fi

if [[ -z "$2" ]]; then
	usage
fi

K3S_TOKEN=$1
K3S_SERVER=$2

curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="agent" K3S_TOKEN=$K3S_TOKEN sh -s - --server=$K3S_SERVER

