# README

This directory stands up a k3s HA cluster with MetalLb and Ingress-Nginx for LoadBalancer and Ingress Resources on 
Bare-Metal servers. 

## Deployment steps

1. Clone the repository on two or more machines.

```shell
git clone https://github.com/ngtrimble/k8s.git
```

2. On server #1, run:

```shell
./01-upgrade-install-k3s-server.sh -u
```

3. On server #1,

Update the variables below in 02-install-metallb-ingress-nginx.sh for your network.

METALLB_IPADDRESSPOOL=192.168.68.20/32
NGINX_LB_IP=192.168.68.20

Run:

```shell
./02-install-metallb-ingress-nginx.sh
```

4. On server #2, run:

```shell
./03-join-upgrade-install-k3s-cluster.sh
```

5. On server #1, run:

```shell
./04-create-test-app.sh
```
