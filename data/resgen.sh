#!/bin/bash
if [[ "$EUID" -ne "0" ]] ; then
    echo run with sudo
    sudo $0
    exit $?
fi
cd "$( dirname ""$0"" )"
CDIR="$(pwd)"

BIN="${CDIR}/resgen"
MODDIR="$( dirname ""${CDIR}"" )"

# begn checks
if [ ! -f "${BIN}" ] ; then
	echo " binary file ""${BIN}"" not found. exit"
	exit 1
fi

if [ ! -d "${MODDIR}/maps" ] ; then
	echo " maps directory ""${MODDIR}/maps"" not found. exit"
	exit 1
fi

${BIN} -e "${MODDIR}" -r "${MODDIR}/maps" -mvuns
[ $? -eq 0 ] && ( echo -e '\n\n === \n ALL ok...' ) || exit $?
