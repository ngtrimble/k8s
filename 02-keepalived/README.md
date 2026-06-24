# README.md

## Example(s)

Installs keepalived on two servers with a VIP / LB of 192.168.68.30 and priority set appropriately
such that the first server (192.168.68.20) will have priority over the 2nd.


```
ssh -i ~/.ssh/proxmox-ssh-key pveuser@192.168.68.20 'sudo bash -s -- -l 192.168.68.30/24 -i eth0 -p 100 -r 51' < install-keepalived.sh
ssh -i ~/.ssh/proxmox-ssh-key pveuser@192.168.68.21 'sudo bash -s -- -l 192.168.68.30/24 -i eth0 -p 99 -r 51' < install-keepalived.sh
```

## Test

Use arping to test

```
sudo arping 192.168.68.30             
Password:
ARPING 192.168.68.30
60 bytes from bc:24:11:5c:31:5d (192.168.68.30): index=0 time=8.924 msec
60 bytes from bc:24:11:5c:31:5d (192.168.68.30): index=1 time=6.878 msec
60 bytes from bc:24:11:5c:31:5d (192.168.68.30): index=2 time=9.183 msec
60 bytes from bc:24:11:5c:31:5d (192.168.68.30): index=3 time=7.029 msec
```
