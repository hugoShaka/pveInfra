# -*- mode: ruby -*-
# vi: set ft=ruby :


ansible_groups = {
  "proxmox" => ["roquefort", "camembert", "morbier"],
  "wireguard" => ["roquefort", "camembert", "morbier"],
  "consul_server" => ["roquefort", "camembert", "morbier"],
  "pve_first_node" => ["roquefort"],
}

ansible_host_vars = {
  "roquefort" => {
    "internal_ip" => "10.10.10.1",
    "internal_net" => "10.10.10.0/24",
    "internal_net_prefix" => "10.10.10",
    "nat_interface" => "eth0",
    "wg_public_ip" => "10.0.50.100",
    "wg_port" => "9000",
    "pve_public_ip" => "10.0.50.100",
    "consul_datacenter" => "france",
    "pve_cluster_name" => "hugo",
  },
  "camembert" => {
    "internal_ip" => "10.10.11.1",
    "internal_net" => "10.10.11.0/24",
    "internal_net_prefix" => "10.10.11",
    "nat_interface" => "eth0",
    "wg_public_ip" => "10.0.50.101",
    "wg_port" => "9000",
    "pve_public_ip" => "10.0.50.101",
    "consul_datacenter" => "canada",
    "pve_cluster_name" => "hugo",
  },
  "morbier" => {
    "internal_ip" => "10.10.12.1",
    "internal_net" => "10.10.12.0/24",
    "internal_net_prefix" => "10.10.12",
    "nat_interface" => "eth0",
    "wg_public_ip" => "10.0.50.102",
    "wg_port" => "9000",
    "pve_public_ip" => "10.0.50.102",
    "consul_datacenter" => "germany",
    "pve_cluster_name" => "hugo",
  },
}

Vagrant.configure(2) do |config|
  config.vm.box = "debian/buster64"
  config.vm.provider "virtualbox" do |v|
    v.memory = 2048
    v.cpus = 1
  end

  config.vm.define "roquefort" do |subconfig|
    subconfig.vm.hostname = "proxmox-roquefort"
    subconfig.vm.network "forwarded_port", guest: 8006, host: 8005
    subconfig.vm.network "forwarded_port", guest: 80, host: 8080
    subconfig.vm.network "forwarded_port", guest: 8500, host: 8500
    subconfig.vm.provider "virtualbox" do |vb|
      subconfig.vm.network "private_network", ip: "10.0.50.100", name: "personet0", adapter: 2
    end
  end
  config.vm.define "morbier" do |subconfig|
    subconfig.vm.hostname = "proxmox-morbier"
    subconfig.vm.network "forwarded_port", guest: 8006, host: 8004
    subconfig.vm.network "forwarded_port", guest: 80, host: 8081
    subconfig.vm.provider "virtualbox" do |vb|
      subconfig.vm.network "private_network", ip: "10.0.50.102", name: "personet0", adapter: 2
    end
  end
  config.vm.define "camembert" do |subconfig|
    subconfig.vm.hostname = "proxmox-camembert"
    subconfig.vm.network "forwarded_port", guest: 8006, host: 8006
    subconfig.vm.network "forwarded_port", guest: 80, host: 8082
    subconfig.vm.provider "virtualbox" do |vb|
      subconfig.vm.network "private_network", ip: "10.0.50.101", name: "personet0", adapter: 2
    end
    subconfig.vm.provision "ansible" do |ansible|
      ansible.playbook = "install.yml"
      ansible.tags = "ingress,service-discovery"
      ansible.limit = "all"
      ansible.groups = ansible_groups
      ansible.host_vars = ansible_host_vars
      ansible.become = true
    end
  end
end
