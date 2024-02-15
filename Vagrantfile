# -*- mode: ruby -*-
# vi: set ft=ruby :

default_box = 'generic/ubuntu2204'
default_ram = 2048
default_cpus = 1

nodes = [
  { :hostname => 'vagrant_jenkins01',  
    :ip => '192.168.97.101', 
    :forward => '9701', 
    :ram => 2048, 
  },
]

Vagrant.configure("2") do |config|
  nodes.each do |node|
    config.vm.define node[:hostname] do |nodeconfig|
      nodeconfig.vm.box = node[:box] ? node[:box] : default_box
      #nodeconfig.vm.network :private_network, ip: node[:ip]
      #nodeconfig.vm.network :forwarded_port, guest: 22, host: node[:forward], id: 'ssh'

      # disable for wsl
      #nodeconfig.vm.synced_folder '.', '/vagrant', disabled: true
      nodeconfig.vm.synced_folder '.', '/vagrant', disabled: false


      memory = node[:ram]  ? node[:ram]  : default_ram;
      cpus   = node[:cpus] ? node[:cpus] : default_cpus;
      
      nodeconfig.vm.provider :libvirt do |libvirt|
          libvirt.cpus    = cpus.to_s
          libvirt.memory  = memory.to_s
      end

      nodeconfig.vm.provider :virtualbox do |vb|

        # fix for wsl
        #vb.customize [ "modifyvm", :id, "--uartmode1", "disconnected" ]


        vb.customize [
          "modifyvm", :id,
          "--cpuexecutioncap", "90",
          "--cpus", cpus.to_s,
          "--memory", memory.to_s,
        ]


        #vb.gui = true

      end
    end

    #config.vm.provision "shell", inline: $bootstrap

    #if node[:hostname] == 'jenkins-master'
    #  config.vm.provision "ansible_local" do |ansible|
    #    ansible.playbook = "jenkins-master.yml"
    #    ansible.compatibility_mode = "2.0"
    #    ansible.install = false
    #  end
    #  #config.vm.synced_folder ".", "/vagrant"
    #end

  end
end

