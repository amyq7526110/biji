#!/bin/bash 


block_data(){

     #  查看存储pool

     ceph osd lspools

     rbd create image --image-feature layering --size 10G

     rbd create rbd/mhw_image --image-feature layering --size 10G

     rbd list

     rbd info mhw_image

     rbd resize --size 7G  image --allow-shrink

     rbd resize --size 15G mhw_image 

     #  本地映射

     #  rbd map mhw_image


     # 客户端通过krdb

     ssh  client  "yum -y install ceph-common"

     sleep 1

     scp /etc/ceph/ceph.conf client:/etc/ceph/ceph.conf
  
     scp /etc/ceph/ceph.client.admin.keyring  client:/etc/ceph

     #  ssh client "rbd map mhw_image"

     #  ssh client "rbd showmapped"

     

}
kvm_data(){

     rbd create vm1-image  --image-feature layering --size 10G

     rbd info vm1-image 




}
Cephfs(){


    ssh node4  "yum -y install ceph-mds"

    cd /root/ceph-cluster

    ceph-deploy mds create node4

    ceph-deploy admin node4

    ssh node4 "ceph osd pool create  cephfs_data 128"

    ssh node4 "ceph osd pool create   cephfs_metadata 128"

    ssh node4 "ceph mds stat"

    ssh node4 "ceph fs new myfs1  cephfs_metadata cephfs_data"

    ssh node4 "ceph fs ls"

    #  mount -t ceph 192.168.4.51:6789:/ /[...]    
    #+ -o name=admin,secret=`cat ceph.client....`


}
RGW(){
 
     cd /root/ceph-cluster
    
     ceph-deploy install --rgw node5

     ceph-deploy admin node5

     ceph-deploy rgw create node5
      
     scp  /root/rgw.sh   node5:/root
  
     ssh  node5 "bash  /root/rgw.sh"

     sleep 3
    
     curl  192.168.4.55:8000
 

     ssh node5 "radosgw-admin user create --uid='testuser' --display-name='First User'"  >  s3.txt  
   

}

#RGW
#Cephfs
#kvm_data
#block_data

