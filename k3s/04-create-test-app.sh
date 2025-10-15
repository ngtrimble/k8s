#!/usr/bin/env bash
set -e -o pipefail

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
	--annotation nginx.ingress.kubernetes.io/force-ssl-redirect=true \
	--rule="/*=default-web-app:8000" \
	--class=nginx \
	-o yaml --dry-run=client | tee /dev/tty | sudo kubectl apply -f -

cat << EOF
You may test your setup by issuing the following command:

curl -vLk http://YOUR_NGINX_LB_IP
EOF
