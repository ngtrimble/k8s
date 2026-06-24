# README.md

# Example(s)

```
ssh -i ~/.ssh/proxmox-ssh-key pveuser@192.168.68.20 'sudo bash -s -- -l 192.168.68.30/24 -i eth0 -p 100 -r 51' < install-keepalived.sh
ssh -i ~/.ssh/proxmox-ssh-key pveuser@192.168.68.21 'sudo bash -s -- -l 192.168.68.30/24 -i eth0 -p 99 -r 51' < install-keepalived.sh
```
