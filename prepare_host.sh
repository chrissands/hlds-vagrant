#!/bin/bash

cd "$(dirname ""$0"")"

if [[ "$EUID" -ne "0" ]]; then
  sudo $0
  if [[ $? == 0 ]] ; then
    echo 'setup vagrant plugins'
#   vagrant plugin install vagrant-hosts
#   vagrant plugin install vagrant-rekey-ssh
    vagrant plugin install sahara
    vagrant plugin install vagrant-cachier
#    vagrant plugin install vagrant-vbguest
  fi  
  exit $?
fi

    aptitude -R install ruby rubygems rubygems-integration virtualbox virtualbox-dkms vagrant 
    gem install ffi -v '1.9.8'
    find . -type f -print0 | xargs -0 chmod -x
    find . -type f -iname '*.sh' -print0 | xargs -0 chmod +x

#    vagrant plugin uninstall vagrant-hosts
#    vagrant plugin uninstall vagrant-rekey-ssh
#    vagrant plugin uninstall sahara
#    vagrant plugin uninstall vagrant-cachier
#    vagrant plugin uninstall vagrant-vbguest
    
exit 0
