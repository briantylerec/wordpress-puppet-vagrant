Vagrant.configure("2") do |config|
  
  # OS configs
  config.vm.box = "base"
  config.vm.box = "bento/ubuntu-22.04"

  # Network configs
  config.vm.network "forwarded_port", guest: 80, host: 8080
  config.vm.network "private_network", ip: "192.168.33.10"

  # Memory and cpu
  config.vm.provider "virtualbox" do |vb|
    vb.memory = "1024"
    vb.cpus = 2
  end

  # Puppet provision 
  config.vm.provision "shell", inline: <<-SHELL
		sudo wget https://apt.puppetlabs.com/puppet6-release-bionic.deb
		sudo dpkg -i puppet6-release-bionic.deb
		sudo apt-get update
		sudo apt-get install -y puppet-agent
  SHELL
   
   config.vm.provision "puppet" do |puppet|
    puppet.manifests_path = "manifests"
    puppet.manifest_file = "site.pp"
    puppet.module_path = "modules"        
  end
end
