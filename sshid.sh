#!/bin/bash
echo "请输入要传输的网址："
read -a ip
ln=lnmp_soft.tar.gz  
cd ~
[  !  -f   $ln     ]&& echo "没有$ln" && exit
for ((i=0; i < ${#ip[@]}; i++))
do
ssh-copy-id -f   192.168.${ip[i]}
scp $ln  root@192.168.${ip[i]}:/root
scp maopao.sh root@192.168.${ip[i]}:/root
scp lnmp.sh   root@192.168.${ip[i]}:/root
scp tomcat.sh root@192.168.${ip[i]}:/root
scp zabbix.sh root@192.168.${ip[i]}:/root
scp zabbix_agent.sh root@192.168.${ip[i]}:/root
scp mysql-5.7.17.tar  root@192.168.${ip[i]}:/root
scp mysql.sh  root@192.168.${ip[i]}:/root
scp lnmp_v2.sh  root@192.168.${ip[i]}:/root
done
       
