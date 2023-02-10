# -*- mode: ruby -*-
# vi: set ft=ruby :

ENV['VAGRANT_NO_PARALLEL'] = 'yes'

Vagrant.configure(2) do |config|

    # config.vm.provision "shell", path: "bootstrap.sh"
    # config.vm.provision "shell", path: "cri-o.sh"
    # config.vm.provision "shell", path: "containerd.sh"

    # Kubernetes Master Server
    config.vm.define "kmaster" do |kmaster|
      kmaster.vm.box = "ubuntu/focal64"
      kmaster.vm.hostname = "kmaster.example.com"
      kmaster.vm.network "private_network", ip: "192.168.60.100"
      kmaster.vm.provider "virtualbox" do |v|
        v.name = "kmaster"
        v.memory = 2048
        v.cpus = 2
      end
      kmaster.vm.provision "shell", path: "master.sh"
    end
  
    NodeCount = 1
  
    # Kubernetes Worker Nodes
    (1..NodeCount).each do |i|
      config.vm.define "kworker#{i}" do |workernode|
        workernode.vm.box = "ubuntu/focal64"
        workernode.vm.hostname = "kworker#{i}.example.com"
        workernode.vm.network "private_network", ip: "192.168.60.10#{i}"
        workernode.vm.provider "virtualbox" do |v|
          v.name = "kworker#{i}"
          v.memory = 1024
          v.cpus = 1
        end
        workernode.vm.provision "shell", path: "worker.sh"
      end
    end
  
  end
  
