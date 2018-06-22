# -*- mode: ruby -*-
# vi: set ft=ruby :

require './vars.rb'
$VARS[:VHOME] = "/home/vagrant"

%w[
  vagrant-vbguest
  vagrant-reload
].each do |plugin|
  if (ARGV[0] == 'up') && (Vagrant.has_plugin?(plugin) == false)
    puts " "
    puts "  Warning! Missing plugin!"
    puts "  -----------------------------------------"
    puts "  vagrant plugin install #{plugin}"
    puts "  -----------------------------------------"
    puts " "
    exit
  end
end

Vagrant.configure("2") do |config|
  # check/output version of vbox guest extensions on VM
  config.vm.synced_folder ".", "#{$VARS[:VHOME]}/workspace/#{$VARS[:PROJECT_DIRECTORY]}", disabled: false

  config.vm.define "dev", primary: true do |dev|
    dev.vm.box = "ubuntu/bionic64"
    dev.vm.hostname = "dev.vm"

    dev.vm.provider "virtualbox" do |v|
      v.memory = 8192
      v.cpus = 4
      v.gui = true
      v.customize ["modifyvm", :id, "--vram", "128"]
      v.customize ["modifyvm", :id, "--clipboard", "bidirectional"]
    end

    dev.vm.provision "file", source: $VARS[:GIT_PRIVKEY_PATH],
    destination: "#{$VARS[:VHOME]}/.ssh/id_rsa"
    dev.vm.provision "shell", path: ".provisioning/gui.sh"
    dev.vm.provision "shell", path: ".provisioning/dev_tools.sh", env: $VARS
end
end
