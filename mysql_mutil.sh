#!/bin/bash

     tar -xf   mysql-5.7.20-linux-glibc2.12-x86_64.tar.gz

      mv  mysql-5.7.20-linux-glibc2.12-x86_64 /usr/local/mysql

      sed -i '$a export PATH=/usr/local/mysql/bin/:$PATH'  /etc/profile

      source /etc/profile

      [ -f /etc/my.cnf ] && mv /etc/my{.cnf,.bak}

echo "[mysqld_multi]
mysqld = /usr/local/mysql/bin/mysqld_safe
mysqladmin = /usr/local/mysql/bin/mysqladmin
user = root

[mysqld1]
port=3307
datadir=/data3307
socket=/data3307/mysql.sock
pid-file=/data3307/mysqld.pid
log-error=/data3307/mysqld.err

[mysqld2]
port = 3308
datadir = /data3308
socket = /data3308/mysql.sock
pid-file = /data3308/mysqld.pid
log-error = /data3308/mysqld.err

[mysqld3]
port=3306
datadir=/var/lib/mysql
socket=/tmp/mysql.sock
pid-file=/var/lib/mysql/mysqld.pid
log-error=/var/lib/mysql/mysqld.err
      "       > /etc/my.cnf

      mkdir /data3307
      mkdir /data3308
      mkdir /var/lib/mysql

      useradd mysql

      chown mysql:mysql   /var/lib/mysql
      chown mysql:mysql   /data3307
      chown mysql:mysql   /data3308

    #  mysqld --user=mysql --basedir=/usr/local/mysql --datadir=/data3307 --initialize

#      mysqld_multi start 1
#      
#      mysqld_multi start 2  

