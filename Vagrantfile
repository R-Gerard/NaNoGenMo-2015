# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "chef/centos-7.0"

  config.vm.network :forwarded_port, guest: 8080, host: 8080

  config.vm.provision :shell, path: "bootstrap.sh"

  config.vm.provider "virtualbox" do |v|
    v.memory = 2048
    v.cpus = 2
  end
end
