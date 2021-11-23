

Vagrant.configure(2) do |config|
  config.vm.box_check_update = false

  # vbox template for all vagrant instances
  config.vm.provider "virtualbox" do |vb|
    vb.gui = false
    vb.memory = "512"
    vb.cpus = 2
  end

             config.vm.define "vg-elk-01" do |k8scluster|
                # k8scluster.vm.box = "bento/centos-stream-8"
                k8scluster.vm.box = "bento/ubuntu-20.04"
                k8scluster.vm.hostname = "vg-elk-01"
                k8scluster.vm.network "private_network", ip: "192.168.20.15"
                k8scluster.vm.network :forwarded_port, guest: 22, host: 2201
                #Disabling the default /vagrant share can be done as follows:
                k8scluster.vm.synced_folder ".", "/vagrant", disabled: true
                k8scluster.vm.provider "virtualbox" do |vb|
                    vb.name = "vbox-elk-01"
                    vb.memory = "512"
                end
                k8scluster.vm.provision :shell, path: "provisioning/bootstrap.sh"
                k8scluster.vm.provision :shell, path: "scripts/deploy-elk-v1.sh"
              end

              # use a public network is to allow the IP to be assigned via DHCP
              # https://www.vagrantup.com/docs/networking/public_network
              config.vm.define "vg-elk-02" do |k8scluster|
                k8scluster.vm.box = "bento/centos-stream-8"
                k8scluster.vm.hostname = "vg-elk-02"
                k8scluster.vm.network "public_network"
                #Disabling the default /vagrant share can be done as follows:
                k8scluster.vm.synced_folder ".", "/vagrant", disabled: true
                k8scluster.vm.provider "virtualbox" do |vb|
                    vb.name = "vbox-elk-02"
                    vb.memory = "512"
                end
                k8scluster.vm.provision :shell, path: "provisioning/bootstrap.sh"
                k8scluster.vm.provision :shell, path: "scripts/deploy-elk-v1.sh"
              end
             
              # Static IP via DHCP  manually set the IP of your bridged interface
              # https://www.vagrantup.com/docs/networking/public_network
              config.vm.define "vg-elk-03" do |k8scluster|
                k8scluster.vm.box = "bento/centos-stream-8"
                k8scluster.vm.hostname = "vg-elk-03"
                k8scluster.vm.network "public_network", ip: "192.168.0.17"
                #Disabling the default /vagrant share can be done as follows:
                k8scluster.vm.synced_folder ".", "/vagrant", disabled: true
                k8scluster.vm.provider "virtualbox" do |vb|
                    vb.name = "vbox-elk-03"
                    vb.memory = "512"
                end
                k8scluster.vm.provision :shell, path: "provisioning/bootstrap.sh"
                k8scluster.vm.provision :shell, path: "scripts/deploy-elk-v1.sh"
              end              
  

end
