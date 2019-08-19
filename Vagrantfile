# -*- mode: ruby -*-
# vi: set ft=ruby :
#

ansible_groups = {
  "wireguard" => ["north", "south"],
}

ansible_host_vars = {
  "north" => {
    "internal_ip" => "10.10.10.1",
    "internal_net" => "10.10.10.0/24",
    "internal_net_prefix" => "10.10.10",
    "nat_interface" => "eth0",
    "wg_public_ip" => "10.0.50.100",
    "wg_port" => "9000",
    "pve_public_ip" => "10.0.50.100"
  },
  "south" => {
    "internal_ip" => "10.10.11.1",
    "internal_net" => "10.10.11.0/24",
    "internal_net_prefix" => "10.10.11",
    "nat_interface" => "eth0",
    "wg_public_ip" => "10.0.50.101",
    "wg_port" => "9000",
    "pve_public_ip" => "10.0.50.101"
  },
}

Vagrant.configure(2) do |config|
  config.vm.box = "debian/buster64"
  config.vm.provider "virtualbox" do |v|
    v.memory = 4096
    v.cpus = 2
  end

  config.vm.define "north" do |subconfig|
    subconfig.vm.hostname = "proxmox-north"
    subconfig.vm.network "forwarded_port", guest: 8006, host: 8005
    subconfig.vm.provider "virtualbox" do |vb|
      subconfig.vm.network "private_network", ip: "10.0.50.100"
    end
  end
  config.vm.define "south" do |subconfig|
    subconfig.vm.hostname = "proxmox-south"
    subconfig.vm.network "forwarded_port", guest: 8006, host: 8006
    subconfig.vm.provider "virtualbox" do |vb|
      subconfig.vm.network "private_network", ip: "10.0.50.101"
    end
    subconfig.vm.provision "ansible" do |ansible|
      ansible.playbook = "install.yml"
      ansible.limit = "all"
      ansible.groups = ansible_groups
      ansible.host_vars = ansible_host_vars
      ansible.become = true
    end
  end
end
