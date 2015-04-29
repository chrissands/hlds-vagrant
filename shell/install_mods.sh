#!/bin/bash
if [[ "$EUID" -ne "0" ]] ; then
    echo run with sudo
    sudo $0
    exit $?
fi
cd "$( dirname ""$0"" )"

csdir="/opt/hlds/cstrike"

echo ' == [ INSTALL MODS SCRIPT ] == '

if [ ! -d "${csdir}/addons/" ] ; then
	echo ' => copy addon files ... '
	cp -purRf /vagrant_data/cs_mod/* ${csdir}/
	chown -Rf steamuser:steamuser ${csdir}
	chmod 775 $( find  ${csdir} -type d )
	chmod 664 $( find  ${csdir} -type f )
	[ $? -eq 0 ] && ( echo -n ' ok.' ) || exit $?
	
	echo ' => replace gamedll'
	sudo -n -u steamuser sed -i "s|""gamedll "".*|""gamedll \"addons/metamod/dlls/metamod.dll\" ""|g" ${csdir}/liblist.gam
	sudo -n -u steamuser sed -i "s|""gamedll_osx "".*|""gamedll_osx \"addons/metamod/dlls/metamod.dylib\" ""|g" ${csdir}/liblist.gam
	sudo -n -u steamuser sed -i "s|""gamedll_linux "".*|""gamedll_linux \"addons/metamod/dlls/metamod.so\" ""|g" ${csdir}/liblist.gam
	[ $? -eq 0 ] && ( echo -n ' ok.' ) || exit $?
	
#cat ${csdir}/liblist.gam:
fi
