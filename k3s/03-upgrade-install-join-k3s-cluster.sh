#!/usr/bin/env bash
set -e -o pipefail 

usage() {
cat << EOF
$0 [-u] [-h]

        -u - Uninstall k3s completely before installation or upgrade

        -a - k3s agent arguments

        -h - Help or usage
EOF
exit 1
}

# These are default args for a k3s configuration that works with MetalLB on bare-metal installations
K3S_AGENT_ARGS="--kube-proxy-arg proxy-mode=ipvs --kube-proxy-arg ipvs-strict-arp"
while getopts "a:hu" opt; do
        case $opt in
                a)
                K3S_AGENT_ARGS="$OPTARG"
                ;;
                u)
                UNINSTALL=true
                ;;
                h)
                usage
                ;;
                *)
                usage
                ;;
        esac
done

if [[ -f "/usr/local/bin/k3s-agent-uninstall.sh" && $UNINSTALL ]]; then
        read -p "This will uninstall k3s before installing it. Are you sure y/n?" CONFIRM
        if [[ $CONFIRM == y ]]; then
                /usr/local/bin/k3s-uninstall.sh
        else
                usage
        fi
fi

curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="server $K3S_SERVER_ARGS" sh -s -



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

