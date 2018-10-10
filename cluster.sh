#!/bin/bash 


iscsi_server(){


    # 判断是否有yum源  

    x=`yum repolist  | awk '/repolist/{print $2}' | sed 's/,//'`

    E_NOYUM=65

    if [[ $x<=0 ]]

    then
         echo "don't have yum source."

	 exit $E_NOYUM
          
    fi

    #     安装 targetcli

    yum -y install targetcli

    #     设定 iqn 名称

    #+    IQN格式 iqn.<date_code>.<reversed_domain>.<string>[:<substring>]

    #+    命名示例： iqn.2013-01.com.tarena.tedu:sata.rack2.disk1

    date_code=`date +%F`

    date_code=${date_code%-*} 

    
    iqn=iqn.$date_code.com.tarena.tedu:$HOSTNAME

    iqn_c=iqn.$date_code.com.tarena.tedu:client
  
    yum -y install expect

    expect <<EOR
   spawn targetcli
   expect "/>"            {send "/backstores/block create name=iscsi_store dev=/dev/vdb\r"}
   expect "/>"            {send "iscsi/ create $iqn\r"}
   expect "/>"            {send "iscsi/$iqn/tpg1/luns create /backstores/block/iscsi_store\r"}
   expect "/>"            {send "iscsi/$iqn/tpg1/acls create $iqn_c\r"}
   expect "/>"            {send "saveconfig\r"}
   expect "/>"            {send "exit\r"}
EOR

   systemctl restart target

   systemctl enable  target 
  
   echo "$iqn"

   echo 

   echo "$iqn_c"
}
iscsi_client(){

    read -p "please input iscsi_client iqn: "  client
    read -p "please input iscsi_server ip: "  ip
  
    E_NOI=65
  
    [ -z $client ] && echo  "Usage: `basename $0` input iqn" && exit $E_NOI

    [ -z $ip ] && echo  "Usage: `basename $0` input ip" && exit $E_NOI

    yum -y install iscsi-initiator-utils
  

    iscof=/etc/iscsi/initiatorname.iscsi

    sed -ri 's/=(.*)/='$client'/'  $iscof

    systemctl restart iscsid

    systemctl enable iscsid

    #  发现iscsi 设备

     iscsiadm --mode discoverydb --type sendtargets --portal $ip --discover 

     x=`iscsiadm --mode discoverydb --type sendtargets --portal $ip --discover`

     y=`echo $x | awk '{print $2}'`
    
     systemctl restart iscsi

     systemctl  enable  iscsi

     echo " iscsiadm --mode node --targetname iscsiadm --mode node --targetname $y  --portal $ip:3260 --login"
    
     echo " iscsiadm --mode node --targetname iscsiadm --mode node --targetname $y  --portal $ip:3260 --logout"
}
udev(){


      path=`udevadm info  -q path -n /dev/sda`
  
      udevadm info -q all -p  $path  -a  > udevadm.txt

       sub=`awk  '/SUBSYSTEM=/{print $0}' udevadm.txt`
 
       size=`awk  '/size/{print $0}'       udevadm.txt`
  
       mod=`awk  '/model/{print $0}'      udevadm.txt`
 
       vendor=`awk  '/vendor/{print $0}'     udevadm.txt`

       sub=`echo "$sub"`
 
       size=`echo "$size"`
  
       mod=`echo "$mod"`
 
       vendor=`echo "$vendor"`
 
       sym='SYMLINK+="iscsi/vdb"'      

     echo "$sub, $size, $mod, $vendor, $sym"  > /etc/udev/rules.d/50-iscsidisk.rules
   
}
multi_path(){


#        yum -y install device-mapper-multipath

        mpathconf --user_friendly_names n    

        x=`/usr/lib/udev/scsi_id --whitelisted --device=/dev/sda`

 

        
           echo  "multipaths{
   multipath {

        wwid "$x"
        alias mpatha
   }  

}"          >> /etc/multipath.conf

        
     
       systemctl start multipathd
   
       systemctl enable multipathd
     
       multipath -rr
   
       multipath -ll


}
#iscsi_server 
#iscsi_client
#udev
multi_path
