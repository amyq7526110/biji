#!/bin/bash



myc(){
     read -p "请输入master ip："   ip

     read -p "请输入日志文件名："  log_name 
  
     read -p "请输入日志偏移数："  pos
     

     local  a=(`cat /etc/sysconfig/network-scripts/ifcfg-eth*  | awk -F= '/IPADDR/{print $2}' | awk   -F.  '{print $4}'`)

#    开启主
 
#    sed -i  '/\[mysqld]/a  binlog-format="mixed"'  /etc/my.cnf
#    sed -i  '/\[mysqld]/a  log-bin=host'${a[0]}''  /etc/my.cnf

#    开启主 -》 从 《-  从

#    sed -i  '/\[mysqld]/a  log_slave_updates'      /etc/my.cnf

     if  ! grep -q server_id   /etc/my.cnf  ;then     

     sed -i  '/\[mysqld]/a  server_id='${a[0]}''    /etc/my.cnf

     fi

     systemctl restart mysqld

#  mysql -e    "grant replication slave on  *.*  to repluser@'%'  identified by 'Azsd1234.';"

     mysql -e "change master to
master_host='$ip',
master_user='repluser',
master_password='Azsd1234.',
master_log_file='$log_name',
master_log_pos=$pos;start slave;"
  
    sleep 1
  
    mysql  -e "show slave status\G;"

echo -e "\033[0m"
}
myz(){
    local a=(`cat /etc/sysconfig/network-scripts/ifcfg-eth*  | awk -F= '/IPADDR/{print $2}' | awk   -F.  '{print $4}'`)

#    开启主 

     sed -i  '/\[mysqld]/a  binlog-format="mixed"'  /etc/my.cnf
     sed -i  '/\[mysqld]/a  log-bin=host'${a[0]}''  /etc/my.cnf

#    开启主从从

#    sed -i  '/\[mysqld]/a  log_slave_updates'      /etc/my.cnf

     if ! grep -q server_id   /etc/my.cnf  ; then

     sed -i  '/\[mysqld]/a  server_id='${a[0]}''    /etc/my.cnf
 
     fi

     systemctl restart mysqld

     mysql -e "grant replication slave  on *.*  to repluser@'%' identified by 'Azsd1234.';"

     mysql -e "show master status;"

     echo -e "\033[0m"

}

myb(){
 
  # 查看是否允许动态加载模块
  #     – 默认允许
 
     mysql -e "show variables like 'have_dynamic_loading';"
 
  # 命令行加载插件
  #     – 用户需有SUPER权限
   

     mysql -e "install plugin rpl_semi_sync_master soname 'semisync_master.so';"    

     mysql -e "install plugin rpl_semi_sync_slave  soname 'semisync_slave.so';"
  
     mysql -e "select plugin_name,plugin_status from information_schema.plugins where plugin_name like '%semi%';"
  

   # 启用半同步复制
   #    – 在安装完插件后,半同步复制默认是关闭的

     mysql -e "set global rpl_semi_sync_master_enabled = 1;"
 
     mysql -e "set global rpl_semi_sync_slave_enabled = 1;"

     mysql -e "show variables like 'rpl_semi_sync_%_enabled';"

   # 永久启用半同步复制
   
    # 需要修改到主配置文件 /etc/my.cnf 添加相关设置到 [mysqld] 部分

      sed -i '/\[mysqld]/a  plugin-load="rpl_semi_sync_master=semisync_master.so;rpl_semi_sync_slave=semisync_slave.so"'  /etc/my.cnf
 
      sed -i '/\[mysqld]/a  rpl-semi-sync-master-enabled=1'  /etc/my.cnf

      sed -i '/\[mysqld]/a  rpl-semi-sync-slave-enabled=1'  /etc/my.cnf   
    
#     systemctl  restart mysqld          
   

     echo -e "\033[0m"
}

menu(){
echo -e "\033[0m"
clear
echo -e "\033[41;32m ############################################ \033[0m"
echo -e "\033[41;32m #        1:安装主mysql                     # \033[0m"
echo -e "\033[41;32m #        2:安装从mysql                     # \033[0m"
echo -e "\033[41;32m #        3:设置半同步复制                  # \033[0m"
echo -e "\033[41;32m #        q:退出                            # \033[0m"
echo -e "\033[41;32m ############################################ \033[0m"
echo -ne "\033[40;32m "
read -p "please your choice [1,2,3,q]:"  choice
}
menu
case $choice in
1)
myz ;;
2)  
myc ;;
3)
myb ;;
q|Q)
echo -e "\033[0m"
exit ;;
*)
echo -e "\033[0m"
echo "bye!"
exit
;;
esac  





















#   主库配置选项
#  • 适用于Master服务器

#       binlog_do_db=name 设置Master对哪些库记日志
#       binlog_ignore_db=name 设置Master对哪些库不记日志从库配置选项


#  • 适用于Slave服务器

#       log_slave_updates   记录从库更新,允许链式复制(A-B-C)

#       relay_log=dbsvr2-relay-bin   指定中继日志文件名

#       replicate_do_db=mysql 仅复制指定库,其他库将被忽略,此选项可设置多条(省略时复制所有库)
#       replicate_ignore_db=test不复制哪些库,其他库将被忽略

#       ignore-db与do-db只需选用其中一种


