#!/bin/bash

#  qcow2 格式的虚拟机模板,及路径  

   basevm=rh7_template

   img_dir=/var/lib/libvirt/images

#  设定创建 虚拟机个数

   read -p "number of vm : "  number

   read -p "你是否需要配置网卡，主机名：y/n  :"  ans    

   if    echo $number |  grep -q  [^0-9] 
  
   then 
  
       echo "请输入纯数字"
   
       exit 1

   elif [   $number  -gt  9   -o  $number  -lt  1  ]

   then 

       echo "请输入1～9" 
   
       exit 2

   fi

#  设定 虚拟机最大个数


       counter=0

       vms=0
 
       num=`virsh list  --all | grep rh7 | wc -l`

       if [ $num   -ge   20   ];then 

       echo  -e  "\033[31m you only have 20  virtual  machines  \033[0m"

       exit  3

       fi

#     创建虚拟机

       while [   $vms  -lt  $number   ]

       do
   
           let counter++ 
    
           newvm=rh7_node${counter} 

           if [  -f ${img_dir}/${newvm}.img  ];then

              continue

           fi

           qemu-img create -f qcow2 -b ${img_dir}/.rh7_template.img ${img_dir}/${newvm}.img &> /dev/null

           cat    /var/lib/libvirt/images/.rhel7.xml  > /tmp/myvm.xml

           sed -i "/<name>${basevm}/s/${basevm}/${newvm}/"  /tmp/myvm.xml    
   
           sed -i "/${basevm}\.img/s/${basevm}/${newvm}/"   /tmp/myvm.xml

           virsh define /tmp/myvm.xml  &> /dev/null

           echo -e  "created ${newvm}\t\t\t\t\t\t\033[32;1m[Done]\033[0m" 

           let vms++

 
#     修改虚拟机 的网卡，yum ，hostname

           if [   "$ans"  ==  "y"      ];then
        
           read -p "请输入你要配置的网卡，及ip ，和 虚拟机主机名：" eth ip hostname
           echo   
           echo -e  "\033[31m  正在为${newvm}进行配置 \033[0m"

           [ ! -d  /home/kvm  ]&& mkdir  /home/kvm

           guestmount -d ${newvm}   -i /home/kvm/
 
           cd /home/kvm
          
           wk=etc/sysconfig/network-scripts
            
           ls  ${wk}/ifcfg-${eth}  &>/dev/null

           if  [  $? -eq  0     ];then            

           sed -ri '/BOOTPROTO/s/=(.*)/=static/'  ${wk}/ifcfg-${eth}

           sed -ri '$a IPADDR='$ip''   ${wk}/ifcfg-${eth}

           sed -ri '$a NETMASK=255.255.255.0'  ${wk}/ifcfg-${eth}

           sed -ri '/ONBOOT/s/=(.*)/=yes/'  ${wk}/ifcfg-${eth}

           else  
      
           cat  ${wk}/ifcfg-eth0  >  ${wk}/ifcfg-${eth}

           sed -ri  's/eth0/'$eth'/g'   ${wk}/ifcfg-${eth}

           sed -ri '/BOOTPROTO/s/=(.*)/=static/'  ${wk}/ifcfg-${eth}

           sed -ri '$a IPADDR='$ip''   ${wk}/ifcfg-${eth}

           sed -ri '$a NETMASK=255.255.255.0'  ${wk}/ifcfg-${eth}

           sed -ri '/ONBOOT/s/=(.*)/=yes/'  ${wk}/ifcfg-${eth}

           x=`uuidgen`

           sed -ri '/UUID/s/=(.*)/='$x'/'  ${wk}/ifcfg-${eth}

           fi

#          GATEWAY=192.168.4.254,DNS1=8.8.8.8

           echo  $hostname  > etc/hostname

           yum=`echo  $ip  | sed -r  's/(.*)\.(.*)\.(.*)\.(.*)/\1\.\2\.\3\.254/'`

           echo "[rhel7]
name=rhel7.0
baseurl=ftp://${yum}/rhel7
enabled=1
gpgcheck=0"  >  etc/yum.repos.d/rhel7.repo

            cd 

            umount /home/kvm
   
            
           fi
   
           virsh start ${newvm}  &> /dev/null
   
           sleep 1

           virsh destroy ${newvm}  &> /dev/null
           virsh start ${newvm}    &> /dev/null  
done





