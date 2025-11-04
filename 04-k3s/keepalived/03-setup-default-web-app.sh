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


# Create a hello-world deployment, service and ingress 
sudo kubectl create deployment default-web-app --image crccheck/hello-world --port=8000 -n default \
	-o yaml --dry-run=client | tee /dev/tty | sudo kubectl apply -f -

sudo kubectl expose deployment default-web-app -n default --type ClusterIP \
	-o yaml --dry-run=client | tee /dev/tty | sudo kubectl apply -f -

# Creates an ingress that:
#
# * Catches all hosts
# * Sends requests to default-web-app svc
# * Forces redirect to https (using the default TLS certificate in nginx)
#
# Consider carefully if you wish to provide a rule that matches all hosts
# with TLS forced for all hosts. A better approach would be to list rules
# individually for domains or sub-domains with possible wildcards for sub-domains. 
sudo kubectl create ingress default-web-app -n default \
	--rule="/*=default-web-app:8000" \
	-o yaml --dry-run=client | tee /dev/tty | sudo kubectl apply -f -

cat << EOF
You may test your setup by issuing the following command:

curl -vLk http://YOUR_LOADBALANCER_VIP
EOF

