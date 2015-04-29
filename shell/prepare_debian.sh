#!/bin/bash

start_date=$(date +"%s")

if [[ "$EUID" -ne "0" ]]; then
	echo ' sh: -> restart with sudo'
	sudo $0
else

#  aptitude remove localepurge --purge

  echo '=== [ sh provisioning ] === '
  echo ' sh: -> set timezone (localtime)'
  rm -f /etc/localtime

  cp -vf /usr/share/zoneinfo/Asia/Yekaterinburg /etc/localtime
  echo 'Asia/Yekaterinburg' > /etc/timezone


  echo ' sh: -> set locale-gen '
  cat > /etc/locale.gen <<EOL
## 
en_US ISO-8859-1
en_US.ISO-8859-15 ISO-8859-15
en_US.UTF-8 UTF-8
#
ru_RU ISO-8859-5
ru_RU.CP1251 CP1251
ru_RU.KOI8-R KOI8-R
ru_RU.UTF-8 UTF-8

EOL

  cat > /etc/console-cyrillic <<EOL
##
Debconf : YES
Bootsetup: YES

style ter-uni-norm
size 14
encoding utf-8
layout ru
options alt_shift_toggle
ttys /dev/tty[1-6]

EOL

  echo ' sh: -> locale-gen'
  locale-gen > /dev/null
  cat >> /root/.bashrc <<EOL
##
if [[ -f "/etc/bash_completion" ]] ; then
    . /etc/bash_completion
fi

export LANGUAGE=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

EOL

cat >> /home/vagrant/.bashrc <<EOL

##
if [[ -f "/etc/bash_completion" ]] ; then
    . /etc/bash_completion
fi

export LANGUAGE=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

EOL

export LANGUAGE=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
localedef -i en_US -f UTF-8 en_US.UTF-8 > /dev/null

sed -i 's|^mesg n.*$|tty -s \&\& mesg n|gi' /root/.profile

  cat >> /root/.vimrc <<EOL

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Sets how many lines of history VIM has to remember
set history=700

filetype plugin on
filetype indent on

syntax enable

set tabstop=4
set shiftwidth=4
set smarttab

set et 

set wrap

set ai

set showmatch 
set hlsearch
set incsearch
set ignorecase

set lz

set listchars=tab:··
set list

set ffs=unix,dos,mac
set fencs=utf-8,cp1251,koi8-r,ucs-2,cp866

EOL


cat >> /home/vagrant/.vimrc <<EOL

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Sets how many lines of history VIM has to remember
set history=700

filetype plugin on
filetype indent on

syntax enable

set tabstop=4
set shiftwidth=4
set smarttab

set et 

set wrap

set ai

set showmatch 
set hlsearch
set incsearch
set ignorecase

set lz

set listchars=tab:··
set list

set ffs=unix,dos,mac
set fencs=utf-8,cp1251,koi8-r,ucs-2,cp866

EOL
chown vagrant:vagrant /home/vagrant/.vimrc


  cat > /etc/cron.d/ntpupdate <<EOL
#m    h dom mon dow usr cmd
 0    1  *  *   *   root ntpdate -bs pool.ntp.org
 
EOL
  date

  echo ' sh: -> disable password for users "vagrant" and "root"'
  usermod vagrant --lock
  usermod root --lock
  
  echo ' sh: -> GRUB single boot record (disablr recovery'
  sed -i 's|^#GRUB_DISABLE_RECOVERY=.*$|GRUB_DISABLE_RECOVERY="true"|g' /etc/default/grub
  sed -i 's|^GRUB_TIMEOUT=[0-9]$|GRUB_TIMEOUT=1|g' /etc/default/grub
  
  update-grub
  
  echo ' sh: -> copy sources to vm'
  cat /vagrant_conf/pref > /etc/apt/preferences
  cat /vagrant_conf/src > /etc/apt/sources.list
  sudo cp -frv /vagrant_conf/d/* /etc/apt/sources.list.d
  sudo cp -frv /vagrant_conf/apt.d/* /etc/apt/apt.conf.d
  
  echo ' sh: -> restore priviveleges'
  chmod -Rv 755 /etc/apt/sources.list.d
  chown -Rv root:root /etc/apt/sources.list.d  
  
  echo ' sh: -> import local keys'
  cd /vagrant_conf/key/
  bash /vagrant_conf/key/add-key.gpg.sh
  cd ~
 
  if [[ ! -z "$(dpkg --print-foreign-architectures | grep amd64)" ]] ; then
    echo ' sh: -> remove i386 architecture'
    dpkg --remove-architecture amd64  > /dev/null
  fi
  
  echo ' sh: -> disable ipv6 at all '
  cat > /etc/sysctl.d/noipv6 <<EOL
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
net.ipv6.conf.lo.disable_ipv6 = 1
net.ipv6.conf.eth0.disable_ipv6 = 1
net.ipv6.conf.eth1.disable_ipv6 = 1
net.ipv6.conf.ppp0.disable_ipv6 = 1
net.ipv6.conf.tun0.disable_ipv6 = 1
EOL

  cat > /etc/apt/apt.conf.d/99-force-ipv4 <<EOL
Acquire::ForceIPv4 true;
Acquire::ForceIPv6 false;
EOL

  sed -i 's|#precedence ::ffff:0:0/96  100|precedence ::ffff:0:0/96  100|g' /etc/gai.conf
  sed -i 's/tcp6/#tcp6/g' /etc/netconfig
  sed -i 's/udp6/#udp6/g' /etc/netconfig

  echo ' sh: -> update all'
  aptitude update > /dev/null

  echo ' sh: -> install debian keyrings'
  apt-get --yes --force-yes install \
    debian-keyring \
    debian-archive-keyring \
    debian-ports-archive-keyring \
    deb-multimedia-keyring \
     > /dev/null

  echo ' sh: -> debian update'
  apt-get --yes update > /dev/null
  apt-get --yes --force-yes upgrade > /dev/null
  aptitude -y safe-upgrade

  echo ' sh: -> setup software'
  apt-get --yes --force-yes --install-suggests install \
   mc ranger \
   htop iftop ncdu coreutils moreutils sysv-rc-conf \
   highlight atool unzip zip p7zip\
   vim-nox vim-scripts \
   tmux screen \
   iputils-ping iputils-tracepath \
   virtualbox-guest-dkms \
   unicode-data ntpdate \
   > /dev/null

end_date=$(date +"%s")
diff=$(($end_date-$start_date))
echo '#########################'
echo "## $(($diff / 60)) minutes and $(($diff % 60)) seconds elapsed."

fi
exit 0
