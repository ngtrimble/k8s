# K8s Troubleshooting

## Swap

Check if swap is on.

```
swapon --show
```

Turn off swap

```
swapoff --all
```

Comment swap in /etc/fstabl to make permanent

```
#UUID=0b68175c-d4da-4440-b7d9-38a9ac74a9a7  swap                    swap   defaults                      0  0
```

## Memory

Check memory usage

```
free -h
               total        used        free      shared  buff/cache   available
Mem:           7.8Gi       1.3Gi       4.2Gi       1.6Mi       2.6Gi       6.5Gi
Swap:             0B          0B          0B
```

## Get other memory details

```
cat /proc/meminfo
```

## Get logs for pod that has been replaced during crashloop 

```
kubectl logs <pod-name> --previous
```

## Describe pod, deploy, etc

```
kubectl describe pod <pod-name>
```

## Check k3s service (kubelet on vanilla k8s)

```
systemctl status k3s.service
```

## Turn off firewalld

```
systemctl disable firewalld
systemctl stop firewalld
```

## Check Storage Health

Check for S.M.A.R.T. errors

```
smartctl -a /dev/sda
```

Search for scsi or error lines

```
dmesg | grep -i "scsi\|error"
```

Check for bad blocks

```
badblocks -sv /dev/sda
```

## File System

List block devices

```
lsblk
```

List open files

```
losf
```

