# -*- mode: ruby -*-
# vi: set ft=ruby :

nodes = [
  { :hostname => 'vagrant_jenkins01',  
    :ip => '192.168.97.101', 
    :box => 'ubuntu/bionic64',
    :forward => '9701', 
    :ram => 2048, 
    :cpus => 2, 
  },
]

Vagrant.configure("2") do |config|
  nodes.each do |node|
    config.vm.define node[:hostname] do |nodeconfig|
      nodeconfig.vm.box = node[:box] ? node[:box] : "ubuntu/bionic64"
      nodeconfig.vm.network :private_network, ip: node[:ip]
      nodeconfig.vm.network :forwarded_port, guest: 22, host: node[:forward], id: 'ssh'

      # disable for wsl
      # nodeconfig.vm.synced_folder '.', '/vagrant', disabled: true


      memory = node[:ram]  ? node[:ram]  : 256;
      cpus   = node[:cpus] ? node[:cpus] : 1;

      

      nodeconfig.vm.provider :virtualbox do |vb|

        # fix for wsl
        vb.customize [ "modifyvm", :id, "--uartmode1", "disconnected" ]


        vb.customize [
          "modifyvm", :id,
          "--cpuexecutioncap", "90",
          "--cpus", cpus.to_s,
          "--memory", memory.to_s,
        ]


        #vb.gui = true

      end
    end
  end
end
