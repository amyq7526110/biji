#!/bin/bash

read -p "请输入监控主机ip"  ip 
read -p "请输入你的主机名"  hostname

cd ~

#   安装所的必要压缩包 lnmp_soft.tar.gz
     
       ln=lnmp_soft.tar.gz

       [ !  -f  $ln   ]&& echo "没有lnmp_soft.tar.gz压缩包" && exit

#   源码安装zabbix_agent

       zb=zabbix-3.4.4.tar.gz

       yum -y install gcc pcre-devel

       tar -xf  $ln
     
       cd lnmp_soft/        
       
       tar -xf  $zb

       cd  zabbix-3.4.4/

#       选择模块agent , 编译安装

       ./configure --enable-agent     

       make && make install    

#      修改配置文件
     
     
       sed -ri 's/^Server=(.*)/Server=\1,'$ip'/' /usr/local/etc/zabbix_agentd.conf   
     
       sed -ri 's/^ServerActive=(.*)/ServerActive=\1,'$ip'/' /usr/local/etc/zabbix_agentd.conf 
 
       sed -ri '/^Hostname=/c  Hostname='$hostname'' /usr/local/etc/zabbix_agentd.conf
      
       sed -ri 's/^# Enable(.*)=0/Enable\1=1/' /usr/local/etc/zabbix_agentd.conf

       sed -ri 's/^# Unsafe(.*)=0/Unsafe\1=1/' /usr/local/etc/zabbix_agentd.conf

       sed -ri 's/^# Include(.*)\/$/Include\1\//' /usr/local/etc/zabbix_agentd.conf
#      启动服务

       useradd -s /sbin/nologin  zabbix
 
       zabbix_agentd
