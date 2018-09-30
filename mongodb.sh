#!/bin/bash

#   装包


#   免安装，解压即可使用

    cd ~

    
    M_dir=/usr/local/mongodb

    M_tgz=mongodb-linux-x86_64-rhel70-3.6.3.tgz
  
    M_tgz_dir=mongodb-linux-x86_64-rhel70-3.6.3

    E_nmtgz=65
   
  
    [  ! -f  $M_tgz ] && echo "没有$M_tgz 包" && exit $E_nmtgz
   
    mkdir /usr/local/mongodb

    tar -zxf  $M_tgz
 
    cp -r  $M_tgz_dir/bin   $M_dir/
   
    cd  $M_dir/

    mkdir -p etc log data/db 
   
    ln -n /usr/local/mongodb/bin/*   /bin/

    conf=/usr/local/mongodb/etc/mongodb.conf

    ip=`ifconfig    | awk '/inet/{print $2}' | head -1`

    port=270${ip##*.}
 

    {  
      echo "logpath=/usr/local/mongodb/log/mongodb.log
logappend=true
dbpath=/usr/local/mongodb/data/db
fork=true
bind_ip=$ip
port=$port
"
    }  > $conf

#    降级启动

    sed -i '$a replSet=rs1' $conf

    useradd  -s /sbin/nologin  mongodb
    chown -R mongodb:mongodb /usr/local/mongodb/

    {
   echo "#!/bin/bash
chown -R mongodb:mongodb /usr/local/mongodb/
case \$1 in
-s)
su  - mongodb  -s /bin/bash -c 'mongod -f  /usr/local/mongodb/etc/mongodb.conf --shutdown'  &> /dev/null
;;
-r)
su - mongodb -c 'mongod -f  /usr/local/mongodb/etc/mongodb.conf --shutdown'  -s /bin/bash  &> /dev/null
su - mongodb -c 'mongod -f  /usr/local/mongodb/etc/mongodb.conf'  -s /bin/bash  &> /dev/null
;;
-e)
echo /bin/mongodb  >> /etc/rc.local
chmod +x /etc/rc.local
;;
-de)
if grep -q /bin/mongodb /etc/ec.local ;then
sed  -i  's#/bin/mongodb##' /etc/rc.local
else
echo 没有自起
fi
;;
*)
su - mongodb -c 'mongod -f  /usr/local/mongodb/etc/mongodb.conf'  -s /bin/bash  &> /dev/null
;;
esac"

    }   > mongodb

   chmod +x mongodb

   cp mongodb   /bin/

