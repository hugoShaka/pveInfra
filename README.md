## Introduction

This is the role I use to deploy & manage my few servers.

This :
* Installs proxmox 6
* Setups NAT-ed LAN for proxmox VTs and VMs
* Installs wireguard
* Connects LANs together using wireguard
* Deploys a service-discovery service (consul)
* Deploys load-balancer on each node (fabio)

## Local setup

### Requirements

* ansible >= 2.8
* Vagrant with Virtalbox provider

### First install

```
vagrant up
```

### Connecting web UIs

* https://consul.local.shaka.xyz:8443/
* https://fabio.local.shaka.xyz:8443/
* https://proxmox-morbier.proxmox.local.shaka.xyz:8443/
* https://proxmox-camembert.proxmox.local.shaka.xyz:8443/
* https://proxmox-roquefort.proxmox.local.shaka.xyz:8443/

### Iterating faster

The makefile provides targets that re-use the vagrant-generated inventory.
This is useful to run only specific tags without editing the Vagrantfile.
