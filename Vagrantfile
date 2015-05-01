# -*- mode: ruby -*-
# -*- coding: utf-8 -*-
# vi: set ft=ruby :

require 'time'
# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"
VAGRANTCFG_DOMAIN = "loc"
VAGRANTCFG_HOSTNAME = "csserver"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  
  TIME_START = Time.now.iso8601;
  
  if Vagrant.has_plugin?("vagrant-cachier")
    # Configure cached packages to be shared between instances of the same base box.
    # More info on http://fgrehm.viewdocs.io/vagrant-cachier/usage
    config.cache.scope = :box
    config.cache.synced_folder_opts = {
      mount_options: ['rw,dmode=777,fmode=666']
    }
    # For more information please check http://docs.vagrantup.com/v2/synced-folders/basic_usage.html
  end
  
  config.vm.box = "debian-8.0.0-i386"
  config.vm.box_url = "https://github.com/bercut497/vagrant-box/releases/download/debian-8.0.0-i386/debian-8.0.0-i386.box"
  config.ssh.forward_agent = true

  config.vm.synced_folder "./data", "/vagrant_data", mount_options: ["ro"]
  config.vm.synced_folder "./conf", "/vagrant_conf", mount_options: ["ro"]
  config.vm.synced_folder ".", "/vagrant", disabled: true

  config.vm.define "csserver"  do |cs|
    cs.vm.network "forwarded_port", guest: 27015, host: 27015, protocol: "tcp"
    cs.vm.network "forwarded_port", guest: 27005, host: 27005, protocol: "tcp"
    cs.vm.network "forwarded_port", guest: 27015, host: 27015, protocol: "udp"
    cs.vm.network "forwarded_port", guest: 27005, host: 27005, protocol: "udp"
    cs.vm.provider "virtualbox" do |vb|
      vb.customize ["modifyvm", :id, "--audio", "none"]
      vb.customize ["modifyvm", :id, "--usb", "off"]
      vb.customize ["modifyvm", :id, "--usbehci", "off"]
      vb.customize ["modifyvm", :id, "--memory", "1024"]
      vb.customize ["modifyvm", :id, "--cpuexecutioncap", "85"]
      vb.customize ["modifyvm", :id, "--cpus", "1"]
      vb.customize ["modifyvm", :id, "--hwvirtex", "on"]
      vb.customize ["modifyvm", :id, "--hpet", "on"]
      vb.customize ["modifyvm", :id, "--nestedpaging", "on"]
      vb.customize ["modifyvm", :id, "--vtxvpid", "on"]
      vb.customize ["modifyvm", :id, "--vtxux", "on"]
      vb.customize ["modifyvm", :id, "--snapshotfolder", "./snapshot"]
      vb.customize ["modifyvm", :id, "--nataliasmode1", "proxyonly"]       
      vb.name = "#{VAGRANTCFG_HOSTNAME}.#{VAGRANTCFG_DOMAIN}"
    end
    
    cs.vm.hostname = "#{VAGRANTCFG_HOSTNAME}.#{VAGRANTCFG_DOMAIN}"
    cs.vm.provision :shell, path: './shell/prepare_debian.sh'
    cs.vm.provision :shell, path: './shell/shellshock_test.sh'
    cs.vm.provision :shell, path: './shell/installHlds.sh'
    cs.vm.provision :shell, path: './shell/install_mods.sh'
    cs.vm.provision :shell, path: './shell/install_resgen.sh'
    cs.vm.provision :shell, path: './shell/check_maps.sh'
    cs.vm.provision :shell, path: './shell/clearing.sh', args: ["#{TIME_START}"] 
  end
end
