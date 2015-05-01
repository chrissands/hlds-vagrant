#!/bin/bash
if [[ "$EUID" -ne "0" ]] ; then
    echo run with sudo
    sudo $0
    exit $?
fi
cd "$( dirname ""$0"" )"
CURDIR="$( pwd )"

echo " == [ CHECK MAPS SCRIPT ] == "

csdir="/opt/hlds/cstrike"
if [ ! -d "${csdir}/maps/" ] ; then
    echo " ERROR: cant get ${csdir}/maps/ directory"
    exit 1;
fi

if [ ! -d "/vagrant_data/cs_maps/" ] ; then
    echo " ERROR: cant get /vagrant_data/cs_maps/ directory"
    exit 1;
fi

echo ' => sync additional map files ... '
cp -purRf /vagrant_data/cs_maps/* ${csdir}/
[ $? -eq 0 ] && ( echo -n ' copy ok.' ) || exit $?
chown -Rf steamuser:steamuser "${csdir}/"
[ $? -eq 0 ] && ( echo -n ' owner rules ok.' ) || exit $?
chmod 775 $( find  ${csdir} -type d )
chmod 664 $( find  ${csdir} -type f )

if [ -f "${csdir}/tools/resgen.sh" ] ; then
    cd "${csdir}/tools/"
    if [ ! -x "${csdir}/tools/resgen" ]; then
        chmod +x "${csdir}/tools/resgen"
    fi
    if [ ! -x "${csdir}/tools/resgen.sh" ]; then
        chmod +x "${csdir}/tools/resgen.sh"
    fi

    bash ./resgen.sh
    [ $? -eq 0 ] && ( echo -n ' call resgen ok.' ) || exit $?   
fi
[ $? -eq 0 ] && ( echo -e '\n\n === \n ALL OK.' ) || exit $?
