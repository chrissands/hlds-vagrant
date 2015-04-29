#!/bin/bash
if [ "$EUID" -ne "0" ]; then
 sudo $0
 exit
fi

for f in *.asc; do 
#	gpg --no-default-keyring --keyring ./../gpg/$f.gpg --import $f
	echo $f
	apt-key add $f
done
exit 0
