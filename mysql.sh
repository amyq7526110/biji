#!/bin/bash

#      判断是否有mysql-5.7.17的tar包

     my=mysql-5.7.17.tar

     [ ! -f  $my   ]&& echo "没有${my}包" && exit

#       判断是否有mariadb环境


     [  -f  /usr/bin/mysql  ]&& echo "请确保系统内没有安装mariadb"&& exit
  
#    rm -rf /etc/my.conf
#    rm -rf /var/lib/mysql/*
#    rpm -e --nodeps mariadb mariadb-server

#    安装 mysql

     yum -y install perl-JSON

     tar -xf $my

     rpm -Uvh  mysql-community-*.rpm

#     初始化mysql数据库，密码设为azsd123.

      systemctl enable mysqld

      systemctl start  mysqld

      x=`awk '/password is/{print $NF}' /var/log/mysqld.log`

      yum -y install expect

      echo $x

      expect <<EOF
      
      spawn mysql -uroot -p 
      
      expect "password"      {send "$x\r"}
      
      expect "mysql>"        {send "alter user root@'localhost' identified by 'Azsd1234.';\r"}
      
      expect "mysql>"        {send "quit;\n"}

EOF


#---     免输入密码登陆-----

      sed  -i '$a  [client] \
host=localhost \
port=3306  \
user=root \
password='Azsd1234.'' /etc/my.cnf

      systemctl restart mysqld

