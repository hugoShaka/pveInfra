This :

* creates 2 debian VMs
* Installs proxmox 6
* Setup NAT-ed LAN for proxmox VTs and VMs
* Installs wireguard
* Connect LANs together using wireguard

To alloww consul ui on roquefort :

```
socat -d -d TCP-L:8500,bind=10.0.2.15,fork TCP:localhost:8500
```
