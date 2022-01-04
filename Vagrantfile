# -*- mode: ruby -*-
# vi: set ft=ruby :


$NUM_HYPERVISORS = 1

$ANSIBLE_GROUPS = {
  "proxmox" => ["roquefort", "camembert", "morbier"],
  "wireguard" => ["roquefort", "camembert", "morbier"],
  "consul_server" => ["roquefort", "camembert", "morbier"],
  "pve_first_node" => ["roquefort"],
  "proxmox:vars" => {
    "fabio_admin_password" => "placeholder_for_local",
    "pve_version" => 7,
  },
}

$ANSIBLE_HOST_VARS = {
  "roquefort" => {
    "ansible_python_interpreter" => "/usr/bin/python3",
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
    "ansible_python_interpreter" => "/usr/bin/python3",
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
    "ansible_python_interpreter" => "/usr/bin/python3",
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

def provision_boxes_if_needed(subconfig, box_id)
  # Only the last box is provisionned with the ansible limit to all (select all boxes)
  # This is a hack to provision all the boxes in a single run
  if box_id == $NUM_HYPERVISORS - 1
    subconfig.vm.provision "ansible" do |ansible|
      ansible.playbook = "install.yml"
      # ansible.tags = "ingress,service-discovery"
      ansible.limit = "all"
      ansible.groups = $ANSIBLE_GROUPS
      ansible.host_vars = $ANSIBLE_HOST_VARS
      ansible.verbose = true
      ansible.become = true
    end
  end
end

def configure_boxes(config, box_id)
  # This could be refactored but would likely increase complexity
  case box_id
  when 0
    config.vm.define "roquefort" do |subconfig|
      subconfig.vm.hostname = "proxmox-roquefort"
      subconfig.vm.network "forwarded_port", guest: 8006, host: 8005
      subconfig.vm.network "forwarded_port", guest: 80, host: 8080
      subconfig.vm.network "forwarded_port", guest: 443, host: 8443
      subconfig.vm.network "forwarded_port", guest: 8500, host: 8500
      subconfig.vm.network "private_network", ip: "10.0.50.100", adapter: 2
      provision_boxes_if_needed(subconfig, box_id)
    end
  when 1
    config.vm.define "morbier" do |subconfig|
      subconfig.vm.hostname = "proxmox-morbier"
      subconfig.vm.network "forwarded_port", guest: 8006, host: 8004
      subconfig.vm.network "forwarded_port", guest: 80, host: 8081
      subconfig.vm.network "private_network", ip: "10.0.50.102", adapter: 2
      provision_boxes_if_needed(subconfig, box_id)
    end
  when 2
    config.vm.define "camembert" do |subconfig|
      subconfig.vm.hostname = "proxmox-camembert"
      subconfig.vm.network "forwarded_port", guest: 8006, host: 8006
      subconfig.vm.network "forwarded_port", guest: 80, host: 8082
      subconfig.vm.network "private_network", ip: "10.0.50.101", adapter: 2
      provision_boxes_if_needed(subconfig, box_id)
    end
  else
    "Error : asking more VMs than supported by the Vagrantfile"
  end
end

Vagrant.configure(2) do |config|
  config.vm.box = "debian/bullseye64"
  config.vm.provider "virtualbox" do |v|
    v.memory = 2048
    v.cpus = 1
  end
  (0..$NUM_HYPERVISORS - 1).each do |box_id|
    configure_boxes(config, box_id)
  end
end
