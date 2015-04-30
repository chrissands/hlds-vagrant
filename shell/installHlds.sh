#!/bin/bash
if [[ "$EUID" -ne "0" ]] ; then
    echo run with sudo
    sudo $0
    exit $?
fi
cd "$( dirname ""$0"" )"

echo ' == [ INSTALL HLDS SCRIPT ] == '
#echo ' => install gcc 32 libs'
#sudo apt-get install lib32gcc1 -q -y
#[ $? -eq 0 ] || exit $?

echo ' => add user'
adduser --system --group --disabled-password steamuser
adduser vagrant steamuser

if [[ ! -d "/home/steamuser" ]]; then
  mkdir -p /home/steamuser
  chown -Rvf steamuser:steamuser /home/steamuser
fi
[ $? -eq 0 ] || exit $?

echo ' => create folders '
 mkdir -p /opt/{steam,hlds} 
 chown -Rvf steamuser:steamuser /opt/{steam,hlds} 
 chmod -Rvf 775 /opt/{steam,hlds} 
[ $? -eq 0 ] || exit $?

echo ' => get SteamCmd'
cd /opt/steam

if [[ ! -f steamcmd.sh ]] ; then
    echo '=> steam.sh not fount; get from tar' 
    if [[ ! -f steamcmd_linux.tar.gz ]] ; then
	echo '=> steamcmd_linux.tar.gz not fount; get from web'
        sudo -n -u steamuser wget -c http://media.steampowered.com/installer/steamcmd_linux.tar.gz
	[ $? -ne 0 ] && exit $? || ls -la ./
    fi
    tar -xvzf ./steamcmd_linux.tar.gz
    ls -la ./
    chown -Rvf steamuser:steamuser ./
fi
[ $? -eq 0 ] || exit $?

echo ' => add create symlinks'
sudo -n -u steamuser mkdir -p /home/steamuser/.steam
if [[ ! -d "/home/steamuser/.steam/sdk32" ]] ;then
  sudo -n -u steamuser ln -s /opt/steam/linux32 /home/steamuser/.steam/sdk32
fi
if [[ ! -f "/home/steamuser/.steam/steam" ]] ; then
  sudo -n -u steamuser ln -s /opt/steam/steam.sh /home/steamuser/.steam/steam
fi


#if [[ ! -d "/opt/hlds/steamapps" ]] ; then
#  mkdir -p /opt/hlds/steamapps/
#  chown -R  steamuser:steamuser /opt/hlds
#fi

#if [[ ! -f "./appmanifest_10.acf" ]] ; then
#  cp -v /vagrant_data/appmanifest_10.acf /opt/hlds/steamapps/
#fi

#if [[ ! -f "./appmanifest_70.acf" ]] ; then
#  cp -v /vagrant_data/appmanifest_70.acf /opt/hlds/steamapps/
#fi

#if [[ ! -f "./appmanifest_90.acf" ]] ; then
#  cp -v /vagrant_data/appmanifest_90.acf /opt/hlds/stemapps/
#fi
[ $? -eq 0 ] || exit $?

  echo ' => try get steam files'
if [[ ! -f "./hlds_script.steamcmd" ]] ; then
  cp -v /vagrant_data/hlds_script.steamcmd /opt/steam/
  chown steamuser:steamuser /opt/steam/hlds_script.steamcmd
fi
#  tcount=0;
#  stoploop=0
#  while [ ${stoploop} -eq 0 ] ; do
#    sudo -n -u steamuser ./steamcmd.sh +runscript hlds_script.steamcmd +quit
#    if [ $? -eq 0 ]; then
#        stoploop=1;
#        echo "update success."
#    elif [ ${tcount} -lt 10 ]; then
#        tryes=( ${tcount} +1 );
#        echo " next try ( ${tcount} ) ... "
#    else
#        echo "Cant update files. Try count: ${tryes} . "
#        exit 1
#    fi
#  done  
  echo ' ->  steam app 90 valve files'
  if [[ ! -f "./hlds_valve90.steamcmd" ]] ; then
    cp -v /vagrant_data/hlds_valve90.steamcmd /opt/steam/
    chown steamuser:steamuser /opt/steam/hlds_valve90.steamcmd
  fi
  tcount=0;
  stoploop=0
  while [ ${stoploop} -eq 0 ] ; do
    sudo -n -u steamuser ./steamcmd.sh +runscript hlds_valve90.steamcmd +quit
    if [ $? -eq 0 ]; then
        stoploop=1;
        echo "update success."
    elif [ ${tcount} -lt 10 ]; then
        tryes=( ${tcount} +1 );
        echo " next try ( ${tcount} ) ... "
    else
        echo "Cant update [ app 90 valve ] files. Try count: ${tryes} . "
        exit 1
    fi
  done  

  echo ' ->  steam app 90 cstrike files'
  if [[ ! -f "./hlds_cstrike90.steamcmd" ]] ; then
    cp -v /vagrant_data/hlds_cstrike90.steamcmd /opt/steam/
    chown steamuser:steamuser /opt/steam/hlds_cstrike90.steamcmd
  fi
  tcount=0;
  stoploop=0
  while [ ${stoploop} -eq 0 ] ; do
    sudo -n -u steamuser ./steamcmd.sh +runscript hlds_cstrike90.steamcmd +quit
    if [ $? -eq 0 ]; then
        stoploop=1;
        echo "update success."
    elif [ ${tcount} -lt 10 ]; then
        tryes=( ${tcount} +1 );
        echo " next try ( ${tcount} ) ... "
    else
        echo "Cant update [ app 90 cstrike ] files. Try count: ${tryes} . "
        exit 1
    fi
  done 
  
  echo ' ->  steam app 70 valve files'
  if [[ ! -f "./hlds_valve70.steamcmd" ]] ; then
    cp -v /vagrant_data/hlds_valve70.steamcmd /opt/steam/
    chown steamuser:steamuser /opt/steam/hlds_valve70.steamcmd
  fi
  tcount=0;
  stoploop=0
  while [ ${stoploop} -eq 0 ] ; do
    sudo -n -u steamuser ./steamcmd.sh +runscript hlds_valve70.steamcmd +quit
    if [ $? -eq 0 ]; then
        stoploop=1;
        echo "update success."
    elif [ ${tcount} -lt 10 ]; then
        tryes=( ${tcount} +1 );
        echo " next try ( ${tcount} ) ... "
    else
        echo "Cant update [ app 70 valve ] files. Try count: ${tryes} . "
        exit 1
    fi
  done  
  
  echo ' ->  steam app 10 cstrike files'
  if [[ ! -f "./hlds_cstrike10.steamcmd" ]] ; then
    cp -v /vagrant_data/hlds_cstrike10.steamcmd /opt/steam/
    chown steamuser:steamuser /opt/steam/hlds_cstrike10.steamcmd
  fi
  tcount=0;
  stoploop=0
  while [ ${stoploop} -eq 0 ] ; do
    sudo -n -u steamuser ./steamcmd.sh +runscript hlds_cstrike10.steamcmd +quit
    if [ $? -eq 0 ]; then
        stoploop=1;
        echo "update success."
    elif [ ${tcount} -lt 10 ]; then
        tryes=( ${tcount} +1 );
        echo " next try ( ${tcount} ) ... "
    else
        echo "Cant update [ app 10 cstrike ] files. Try count: ${tryes} . "
        exit 1
    fi
  done  
  cd ~

sudo -n -u steamuser touch /opt/hlds/cstrike/{listip,banned}.cfg
csdir="/opt/hlds/cstrike"

echo ' => disable secure'
sed -i 's|"secure".*|"secure ""0"" "|g' ${csdir}/liblist.gam
[ $? -eq 0 ] || exit $?

if [ ! -f "/etc/init.d/hlds" ] ; then
  echo ' => set daemon'
  cp -v /vagrant_data/hlds-daemon.init /etc/init.d/hlds
  chmod +x /etc/init.d/hlds
  update-rc.d hlds defaults
  [ $? -eq 0 ] || exit $?
  
  echo ' => start daemon'
  service hlds start
  [ $? -eq 0 ] || exit $?
fi

service hlds status
exit 0
