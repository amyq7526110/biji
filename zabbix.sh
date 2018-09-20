#!/bin/bash

#   安装zabbix_server

myzabbix(){

#     判断是否安装lnmp 环境

      if   !  ss -ntplu   |   grep -q nginx ;then

           echo "没有lnmp环境"
           exit 1          
      elif !  ss -ntplu   |   grep -q 9000 ;then
   
           echo "没有lnmp环境" 
           exit 1          
      
      elif !  ss -ntplu   |   grep -q 3306 ;then
    
           echo "没有lnmp环境" 
           exit 1          

      elif ! curl 127.0.0.1/mysql.php  | grep -q  root ;then

           echo "没有lnmp环境"
           exit 1          

      else

           echo -n

      fi

#     安装zabbix服务端  

      cd ~
 
      ln=lnmp_soft.tar.gz

      za=zabbix-3.4.4.tar.gz

#    判断是否有lnmp_soft.tar.gz 压缩包    

      [ ! -f $ln ]&& echo "没有lnmp_soft.tar.gz" && exit

      yum -y install net-snmp-devel curl-devel #安装依赖包

#     源码安装zabbix

      tar -xf $ln

      cd  lnmp_soft/

      [ ! -f $za ]&& echo "没有zabbix-3.4.4.tar.gz" && exit

#   修改nginx 配置
    sed -i  '19a  \    
    fastcgi_buffers 8 16k; \
    fastcgi_buffer_size 32k; \
    fastcgi_connect_timeout 300; \
    fastcgi_send_timeout 300; \ 
    fastcgi_read_timeout 300;'  /usr/local/nginx/conf/nginx.conf

    nginx -s reload

#   安装zabbix

    yum -y install  ./libevent-devel-2.0.21-4.el7.x86_64.rpm

    tar -xf $za

    cd zabbix-3.4.4/

    ./configure --enable-server  --enable-proxy --enable-agent --with-mysql=/usr/bin/mysql_config  --with-net-snmp --with-libcurl

    make && make install

#   配置mysql数据库，导入zabbix数据库

    mysql -e "create database IF NOT EXISTS zabbix character set utf8"
    mysql -e "grant all on zabbix.* to zabbix@'localhost' identified by 'zabbix'"
    cd /root/lnmp_soft/zabbix-3.4.4/database/mysql/

    mysql -uzabbix -pzabbix zabbix < schema.sql
    mysql -uzabbix -pzabbix zabbix < images.sql
    mysql -uzabbix -pzabbix zabbix  <  data.sql

#   拷贝zabbix网页到nginx下，并赋予权限
 
    cd /root/lnmp_soft/zabbix-3.4.4/frontends/php/
    
    cp -r * /usr/local/nginx/html/

    useradd -s /sbin/nologin/ zabbix

    chmod -R 777 /usr/local/nginx/html/*

#   配置 php-fem 服务 

    yum -y install php-gd php-xml
    yum -y install /root/lnmp_soft/php-bcmath-5.4.16-42.el7.x86_64.rpm /root/lnmp_soft/php-mbstring-5.4.16-42.el7.x86_64.rpm

#   修改配置文件

    sed  -ri  's/^# DBPass(.*)/DBPass\1zabbix/' /usr/local/etc/zabbix_server.conf
    sed  -ri  's/^# DBHost(.*)/DBHost\1/' /usr/local/etc/zabbix_server.conf
    sed  -ri 's/^;date.time(.*)/date.time\1 Asia\/Shanghai/'  /etc/php.ini
    sed  -ri 's/^max_executi(.*)= 30/max_executi\1= 300/'  /etc/php.ini
    sed  -ri '/^max_input(.*)/c max_input_time = 300' /etc/php.ini 
    sed  -ri '/^mamory_limit(.*)/c memory_limit = 128M' /etc/php.ini
    sed  -ri '/^post_max(.*)/c post_max_size = 32M' /etc/php.ini  

#   重起服务，启动zabbix

    systemctl restart php-fpm.service
    zabbix_server
}


#   配置zabbix——server  的 zabbix_agent
myagent(){

#   获取本机ip

    ip=$(echo `ifconfig | awk '/inet /{print $2}'` | sed 's/ /,/g')

#   修改zabbix_agent 配置文件

    sed -ri 's/^Server=(.*)/Server='$ip'/'             /usr/local/etc/zabbix_agentd.conf
    sed -ri 's/^ServerActive=(.*)/ServerActive='$ip'/' /usr/local/etc/zabbix_agentd.conf
    sed   -ri 's/^Hostname=(.*)/Hostname=zabbix_server/'  /usr/local/etc/zabbix_agentd.conf
    sed -i 's/# UnsafeUserParameters=0/UnsafeUserParameters=1/' /usr/local/etc/zabbix_agentd.conf

zabbix_agentd

}
myzabbix
myagent
firefox 127.0.0.1/index.php
