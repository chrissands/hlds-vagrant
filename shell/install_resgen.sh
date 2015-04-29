#!/bin/bash
if [[ "$EUID" -ne "0" ]] ; then
    echo run with sudo
    sudo $0
    exit $?
fi
cd "$( dirname ""$0"" )"
CDIR="$(pwd)"

echo ' == [ INSTALL RESGEN SCRIPT ] == '

git --version &>/dev/null
if [ $? -ne 0 ]; then
    echo ' => install git ... '
    apt-get install -y -qq git
    [ $? -eq 0 ] && ( echo -n ' ok.' ) || exit $?
fi

echo ' => create git directory ... '
mkdir -p "/var/git"
[ $? -eq 0 ] && ( echo -n ' ok.' ) || exit $?

if [ ! -d '/var/git/resgen' ]; then
    mkdir -p '/var/git/resgen'
fi

if [ ! -d '/var/git/resgen/.git' ]; then
    echo ' => clone git resgen ... '
    cd /var/git
    git clone https://github.com/kriswema/resgen.git /var/git/resgen
    [ $? -eq 0 ] && ( echo -n ' ok.' ) || exit $?
    chown -Rf steamuser:steamuser /var/git/resgen
    cd "${CDIR}"
else
    echo ' => update resgen ... '
    cd /var/git/resgen
    git pull
    [ $? -eq 0 ] && ( echo -n ' ok.' ) || exit $?
    chown -Rf steamuser:steamuser /var/git/resgen
    rm -rf ./bin
    cd "${CDIR}"
fi

if [ ! -f '/var/git/resgen/bin/resgen' ]; then
    echo ' => make resgen ... '
    cd /var/git/resgen
    make
    [ $? -eq 0 ] && ( echo -n 'make is ok...' ) || exit $?
    chown -Rf steamuser:steamuser /var/git/resgen
    cd "${CDIR}"
fi

csdir="/opt/hlds/cstrike"
if [ ! -d "${csdir}/tools" ]; then
    mkdir -p "${csdir}/tools"
    [ $? -eq 0 ] && ( echo -n ' ok.' ) || exit $?
    chmod -Rf 777 "${csdir}/tools"
    chown -Rf steamuser:steamuser "${csdir}/tools"
fi

echo ' => copy resgen to tool dir ... '
cp -pvf /var/git/resgen/bin/resgen ${csdir}/tools/
[ $? -eq 0 ] && ( echo -n ' ok.' ) || exit $?

if [ ! -f "${csdir}/tools/resgen.sh" ]; then
  if [ ! -f "/vagrant_data/resgen.sh" ] ; then
    echo "ERROR: /vagrant_data/resgen.sh not found. exit..."
    exit 1
  fi
  cp -purRv /vagrant_data/resgen.sh ${csdir}/tools/resgen.sh
  [ $? -eq 0 ] && ( echo -n ' ok.' ) || exit $?
fi

[ $? -eq 0 ] && ( echo -e '\n\n === \n ALL OK.' ) || exit $?
