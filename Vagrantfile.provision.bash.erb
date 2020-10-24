# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box_check_update = false

  # vbox template for all vagranth instances
  config.vm.provider "virtualbox" do |vb|
    vb.gui = false
    vb.memory = "4096"
    vb.cpus = 2
  end

             config.vm.define "elk-master" do |k8scluster|
                k8scluster.vm.box = "bento/ubuntu-20.04"
                k8scluster.vm.hostname = "elk-master"
                k8scluster.vm.network "private_network", ip: "192.168.50.15"                                
                k8scluster.vm.provider "virtualbox" do |vb|
                    vb.name = "vbox-elk-master"
                    vb.memory = "4096"
                end
                k8scluster.vm.provision :shell, path: "provisioning/bootstrap_elk-master.sh"
              end

             config.vm.define "elk-client01" do |k8scluster|
                k8scluster.vm.box = "bento/ubuntu-20.04"
                k8scluster.vm.hostname = "elk-client01"
                k8scluster.vm.network "private_network", ip: "192.168.50.16"                                
                k8scluster.vm.provider "virtualbox" do |vb|
                    vb.name = "vbox-elk-client01"
                    vb.memory = "4096"
                end
                k8scluster.vm.provision :shell, path: "provisioning/bootstrap_elk-client01.sh"
              end

             config.vm.define "elk-client02" do |k8scluster|
                k8scluster.vm.box = "bento/centos-8.2"
                k8scluster.vm.hostname = "elk-client02"
                k8scluster.vm.network "private_network", ip: "192.168.50.18"                                
                k8scluster.vm.provider "virtualbox" do |vb|
                    vb.name = "vbox-elk-client02"
                    vb.memory = "4096"
                end
                k8scluster.vm.provision :shell, path: "provisioning/bootstrap_elk-client02.sh"
              end

end
