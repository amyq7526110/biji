#!/bin/bash
cof=/etc/maxscale.cnf

yum -y reinstall maxscale-2.1.2-1.rhel.7.x86_64.rpm 

   sed -i '/threads/s/1/auto/' $cof


   sed -rie ":begin; /\[server/,/end/ { /end/! { $! { N; b begin }; }; s/\[server1(.*end)/\[server1\1\n\n\[server2\1/; };" $cof

   sed -rie ":begin; /\[server1/,/0.1/ { /0.1/! { $! { N; b begin }; }; s/(\[server1.*address=).*/\1192.168.4.51/; };"  $cof


   sed -rie ":begin; /\[server2/,/0.1/ { /0.1/! { $! { N; b begin }; }; s/(\[server2.*address=).*/\1192.168.4.52/; };"  $cof

   sed -rie ":begin; /\[Read-Only/,/slave/ { /slave/! { $! { N; b begin }; }; s/\n/\n#/g;s/^/#/ };" $cof

   sed -rie ":begin; /\[Read-Only Lis/,/4008/ { /4008/! { $! { N; b begin }; }; s/\n/\n#/g;s/^/#/ };" $cof

   sed -rie '/^servers/s/$/, server2/' $cof

   sed -ri '/^passwd/s/=.*/=Azsd1234./'  $cof

   sed -rie  ":begin; /\[Read-Write/,/100%/ { /100%/ ! { $! { N; b begin};}; s/(.*)user=(.*)\n(.*)\n(.*)/\1user=scaleuser\n\3\n\4/ }; "  $cof

   sed -rie  ":begin; /^\[MySQL/,/10000/ { /10000/ ! { $! { N; b begin};}; s/(.*)user=(.*)\n(.*)\n(.*)/\1user=scalemon\n\3\n\4/ }; "  $cof

    sed -i   '$a port=4016' $cof

    maxscale -f /etc/maxscale.cnf

    maxadmin  -uadmin -pmariadb -P4016 -e "list servers"


#     tar -xf   mysql-5.7.20-linux-glibc2.12-x86_64.tar.gz

#      mv  mysql-5.7.20-linux-glibc2.12-x86_64 /usr/local/mysql
#
#      sed -i '$a export PATH=/usr/local/mysql/bin/:$PATH'  /etc/profile
#
#      source /etc/profile
# 
#      [ -f /etc/my.cnf ] && mv /etc/my{.cnf,.bak}
#
#      echo "[mysqld_multi]
#      mysqld = /usr/local/mysql/bin/mysqld_safe
#      mysqladmin = /usr/local/mysql/bin/mysqladmin
#      user = root
#      
#      [mysqld1]
#      port=3307
#      datadir=/data3307
#      socket=/data3307/mysql.sock
#      pid-file=/data3307/mysqld.pid
#      log-error=/data3307/mysqld.err
#      
#      [mysqld2]
#      port = 3308
#      datadir = /data3308
#      socket = /data3308/mysql.sock
#      pid-file = /data3308/mysqld.pid
#      log-error = /data3308/mysqld.err
#      "       > a.txt
#      
#      mkdir /data3307
#      mkdir /data3308
#      
#      mysqld_multi start 1
#      
#      mysqld_multi start 2  
