#!/bin/bash 




lvs_nat(){

   #   ipvsadm 
 
   yum -y install ipvsadm
    
   E_NOC=65
    
   read -p "please input lvs_server ip :" se_ip
   
   [ -z $se_ip ] && exit $E_NOC

   ipvsadmin -A -t  $se_ip:80 -s wrr
    
   while : 
      
   do
   
       read -p "please input lvs_client ip"  cl_ip

       if [  "$cl_ip" != "q" ]

       then

       ipvsadmin -a -t  $se_ip:80 -r  $cl_ip:80 -m -w 1

       else
          
	   break
   
       fi

   done

   #      修改集群服务器设置(修改调度器算法，将加权轮询修改为轮询)

   #      ipvsadm -E -t 192.168.4.5:80 -s rr
  
   #      修改read server（将模式改为DR模式）

   #      ipvsadm -e -t 192.168.4.5:80 -r 192.168.2.202 -g

   #      创建另一个集群

   #      ipvsadm -A -t 192.168.4.5:3306 -s lc
   #      ipvsadm -a -t 192.168.4.5:3306 -r 192.168.2.100 -m
   #      ipvsadm -a -t 192.168.4.5:3306 -r 192.168.2.200 -m



   #      保存所有规则

          ipvsadm-save -n > /etc/sysconfig/ipvsadm

	  ipvsadm -C

	  systemctl restart ipvsadm

  #       确认调度器的路由转发功能
 
	  echo 1 > /proc/sys/net/ipv4/ip_forward

	  echo "net.ipv4.ip_forward = 1" >> /etc/sysctl

	  sysctl -p
   

}
lvs_dr(){

     #  安装 ipvsadm

     yum -y install ipvsadm

     #  配置DIP VIP 到网卡的虚拟接口

     wk=/etc/sysconfig/network-scripts/ifcfg-eth0

     cp $wk{,:0}
 
     vip=192.168.4.253     

     sed  -i '$a DEFROUTE=yes'  $wk:0

     sed  -i 's/eth0/eth0:0/g'  $wk:0

     sed  -ri '/IPADDR/s/=(.*)/='$vip'/'  $wk:0

     ipvsadm -C

     ipvsadm -A -t $vip:80 -s wrr

     ipvsadm -a -t $vip:80 -r 192.168.4.52:80 -g -w 1

     ipvsadm -a -t $vip:80 -r 192.168.4.53:80 -g -w 1


     ipvsadm-save -n > /etc/sysconfig/ipvsadm

     systemctl restart network

     echo 1 > /proc/sys/net/ipv4/ip_forward

     echo "net.ipv4.ip_forward = 1" >> /etc/sysctl
                                                                            
}                             
lvc_dr(){
   
    wlo=/etc/sysconfig/network-scripts/ifcfg-lo

    cp $wlo{,:0}
  
    vip=192.168.4.253

    sed -i '/^D/s/lo/lo:0/'                     $wlo:0

    sed -ri '/^I/s/=(.*)/='$vip'/'              $wlo:0

    sed -ri '/^NETM/s/=(.*)/=255.255.255.255/'  $wlo:0

    sed -ri '/^NETW/s/=(.*)/='$vip'/'           $wlo:0

    sed -ri '/^B/s/=(.*)/='$vip'/'              $wlo:0

    sed -ri '/^NAME/s/=(.*)/=lo:0/'             $wlo:0


#    注意：这里因为web1也配置与代理一样的VIP地址，默认肯定会出现地址冲突。
#+   写入这四行的主要目的就是访问192.168.4.5的数据包，
#+   只有调度器会响应，其他主机都不做任何响应。

    sysconf=/etc/sysctl.conf

    sed -i '$a  net.ipv4.conf.all.arp_ignore = 1'  $sysconf
    sed -i '$a  net.ipv4.conf.lo.arp_ignore = 1'   $sysconf
    sed -i '$a  net.ipv4.conf.lo.arp_announce = 2'   $sysconf
    sed -i '$a  net.ipv4.conf.all.arp_announce = 2'   $sysconf

    sysctl -p 


    systemctl restart network


}

keep_lvs_dr(){

     read -p "please input m/s:"  zc 
    
     E_ZC=65    
  
     if [ "$zc" != "m" -a "$zc" != "s"  ];then

        exit $E_ZC

     fi

     vip=192.168.4.252     

     yum -y install keepalived

     kecnf=/etc/keepalived/keepalived.conf

     sed -i  '/192.168.200.16/,$d'  /etc/keepalived/keepalived.conf 

     sed -i  '$a '$vip''   /etc/keepalived/keepalived.conf

     sed -i  '$a  }'  $kecnf

     sed -i  '$a  }'  $kecnf

     sed -i  's/VI_1/lvsha/'  $kecnf
  
     if [ "$zc" == "s"   ];then
 
         sed -i  's/MASTER/BACKUP/'  $kecnf
 
     else 

         sed -i  's/priority 100/priority 150/'  /etc/keepalived/keepalived.conf
     fi


     sed -i '/vrrp_strict/s/^/#/' /etc/keepalived/keepalived.conf

     sed -i  's/1111/123456/'  /etc/keepalived/keepalived.conf

     
echo "virtual_server $vip 80 {
    delay_loop 6
    lb_algo rr
    lb_kind DR
#    persistence_timeout 50
    protocol TCP

    real_server 192.168.4.82 80 {
        weight 1
        TCP_CHECK {
        connect_timeout 3
        nb_get_retry 3
        delay_before_retry 3
        }
    }
    real_server 192.168.4.83 80 {
        weight 1
        TCP_CHECK {
        connect_timeout 3
        nb_get_retry 3
        delay_before_retry 3
        }
    }
}"  >> $kecnf



     #  安装 ipvsadm

     yum -y install ipvsadm


     systemctl restart keepalived    

                                                                            
}                             
keep_lvs_dr
