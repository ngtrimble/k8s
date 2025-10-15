#!/usr/bin/env bash
set -e -o pipefail 

usage() {
cat << EOF
$0 [-u] [-h]

        -u - Uninstall k3s completely before installation or upgrade

        -a - k3s agent arguments

        -h - Help or usage

	-s - k3s server URL (e.g. https://hostname_or_ip:6443)

	-t - k3s server token
EOF
exit 1
}

# These are default args for a k3s configuration that works with MetalLB on bare-metal installations
K3S_AGENT_ARGS="--kube-proxy-arg proxy-mode=ipvs --kube-proxy-arg ipvs-strict-arp"
while getopts "a:hut:s:" opt; do
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
		t)
		K3S_TOKEN="$OPTARG"
		;;
		s)
		K3S_SERVER="$OPTARG"
		;;
                *)
                usage
                ;;
        esac
done

if [[ -z $K3S_SERVER ]]; then
	usage
fi

if [[ -z $K3S_TOKEN ]]; then
	usage
fi

if [[ -f "/usr/local/bin/k3s-agent-uninstall.sh" && $UNINSTALL ]]; then
        read -p "This will uninstall k3s before installing it. Are you sure y/n?" CONFIRM
        if [[ $CONFIRM == y ]]; then
                /usr/local/bin/k3s-agent-uninstall.sh
        else
                usage
        fi
fi

curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="agent $K3S_AGENT_ARGS --server=$K3S_SERVER --token $K3S_TOKEN" sh -s - 
