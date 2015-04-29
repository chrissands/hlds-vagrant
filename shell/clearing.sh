#!/bin/bash
if [[ "$EUID" -ne "0" ]]; then
	echo ' sh: -> restart with sudo'
	sudo $0
else

start_date=$(date +"%s")
init_date=$(date -d "$1" +"%s")
  
  echo ' == [ CLEARING SCRIPT ] =='

  echo ' === restore priviveleges '
  chmod u+rwX,g+rwX,a+rX /etc/
  chown root:root /etc/

  echo ' sh: -> clear APT caches'
  aptitude autoclean > /dev/null
  aptitude clean > /dev/null
  rm -Rf /var/lib/apt/*
  rm -Rf /var/log/installer

  echo ' sh: -> clear space'
  rm -Rf /var/log/*.gz
  rm -Rf /var/log/*.1
  rm -Rf /var/log/*.0 
  for logfile in /var/log/*.log ; do
    echo '' > $logfile
  done
  
  rm -rf /usr/share/doc
  rm -rf /usr/src/vboxguest*
  rm -rf /usr/src/virtualbox-ose-guest*
  rm -rf /usr/src/linux-headers*
  find /var/cache -type f -exec rm -rf {} \;
  rm -rf /usr/share/locale/{af,am,ar,as,ast,az,bal,be,bg,bn,bn_IN,br,bs,byn,ca,cr,cs,csb,cy,da,de,de_AT,dz,el,en_AU,en_CA,eo,es,et,et_EE,eu,fa,fi,fo,fr,fur,ga,gez,gl,gu,haw,he,hi,hr,hu,hy,id,is,it,ja,ka,kk,km,kn,ko,kok,ku,ky,lg,lt,lv,mg,mi,mk,ml,mn,mr,ms,mt,nb,ne,nl,nn,no,nso,oc,or,pa,pl,ps,pt,pt_BR,qu,ro,rw,si,sk,sl,so,sq,sr,sr*latin,sv,sw,ta,te,th,ti,tig,tk,tl,tr,tt,ur,urd,ve,vi,wa,wal,wo,xh,zh,zh_HK,zh_CN,zh_TW,zu}
  
#  umount /vagrant_data
#  echo '==========================='
#  for svc in /etc/init/* ; do
#    service "$(basename ""$svc%.*"")" status
#  done
  echo '==========================='
  df -H
  echo '==========================='  
  
end_date=$(date +"%s")
diff=$(($end_date-$start_date))
diff_t=$(($end_date-$init_date))
echo '#########################'
echo "## $(($diff / 60)) minutes and $(($diff % 60)) seconds elapsed."
echo "## TOTAL: $(($diff_t / 60)) minutes and $(($diff_t % 60)) seconds elapsed."

fi
