#!/bin/bash

cr_osd(){

#    //这两个分区用来做存储服务器的日志journal盘


    parted /dev/vdb mklabel gpt

    parted /dev/vdb mkpart primary 1M 50%

    parted /dev/vdb mkpart primary 50% 100%
  
    sleep 1

    chown ceph.ceph  /dev/vdb1

    chown ceph.ceph  /dev/vdb2

    echo "chown ceph.ceph  /dev/vdb1
chown ceph.ceph  /dev/vdb2"  >> /etc/rc.d/rc.local

    chmod +x /etc/rc.d/rc.local


}
cr_mom(){

    # 判断是否有yum源  

    x=`yum repolist  | awk '/repolist/{print $2}' | sed 's/,//'`

    E_NOYUM=65

    if [[ $x<=0 ]]

    then
         echo "don't have yum source."

         exit $E_NOYUM

    fi


    #   安装 部署软件

    yum install ceph-deploy -y


   #  ceph-deploy --help 

   #  创建目录
    
   cdir=/root/ceph-cluster
  
    [  ! -d  $cdir  ] && mkdir $cdir

   cd $cdir
 
#  创建Ceph集群配置。

    ceph-deploy new node1 node2 node3

#  给所有节点安装软件包。

    ceph-deploy install node1 node2 node3

#  初始化所有节点的mon服务（主机名解析必须对）

    ceph-deploy mon create-initial

#  创建OSD

#   准备磁盘分区

    cr_osd
   
    source /etc/rc.local

    ssh node1 "source /etc/rc.local"
    ssh node2 "/root/ceph.sh"
    ssh node2 "source /etc/rc.local"
    ssh node3 "/root/ceph.sh"
    ssh node3 "source /etc/rc.local"

#   初始化清空磁盘数据（仅node1操作即可）

    ceph-deploy disk zap node1:vdc node1:vdd

    ceph-deploy disk zap node2:vdc node2:vdd

    ceph-deploy disk zap node3:vdc node3:vdd

#   创建OSD存储空间（仅node1操作即可）

    ceph-deploy osd create node1:vdc:/dev/vdb1 node1:vdd:/dev/vdb2  

#   创建osd存储设备，vdc为集群提供存储空间，vdb1提供JOURNAL日志，
#   一个存储设备对应一个日志设备，日志需要SSD，不需要很大


    ceph-deploy osd create node2:vdc:/dev/vdb1 node2:vdd:/dev/vdb2

    ceph-deploy osd create node3:vdc:/dev/vdb1 node3:vdd:/dev/vdb2

    sleep 4

    ceph  -s


    cd ~

}


yyRBD(){

#   创建Ceph块存储

#   实现此案例需要按照如下步骤进行。
#   步骤一：创建镜像

#    1）查看存储池。
#    
#     ceph osd lspools
#    0 rbd,
#    2）创建镜像、查看镜像

#     rbd create demo-image --image-feature  layering --size 10G

#     rbd create rbd/image --image-feature  layering --size 10G

#     rbd list

#     rbd info demo-image
#     rbd image 'demo-image':
#        size 10240 MB in 2560 objects
#        order 22 (4096 kB objects)
#        block_name_prefix: rbd_data.d3aa2ae8944a
#        format: 2
#        features: layering

#    步骤二：动态调整
#    
#    1）缩小容量

#     rbd resize --size 7G image --allow-shrink

#     rbd info image

#    2）扩容容量

#     rbd resize --size 15G image

#     rbd info image

#   通过KRBD访问
#   
#   1）集群内将镜像映射为本地磁盘

#    rbd map demo-image

#   /dev/rbd0
#    lsblk
#   … …
#   rbd0          251:0    0   10G  0 disk

#    mkfs.xfs /dev/rbd0

#    mount  /dev/rbd0  /mnt

#   客户端通过KRBD访问

#     客户端需要安装ceph-common软件包

#     拷贝配置文件（否则不知道集群在哪）

#     拷贝连接密钥（否则无连接权限）


   yum -y install ceph-common 

   scp node1:/etc/ceph/ceph.client.admin.keyring /etc/ceph/

   scp node1:/etc/ceph/ceph.conf /etc/ceph/

#  rbd map image

#  lsblk

#  rbd showmapped
#  id pool image snap device    
#  rbd  image -    /dev/rbd0

#  客户端格式化、挂载分区

#    mkfs.xfs /dev/rbd0

#    mount /dev/rbd0 /mnt/

#    echo "test" > /mnt/test.txt

#    步骤四：创建镜像快照
#
#    1) 查看镜像快照

#      rbd snap ls image

#    2) 创建镜像快照

#      rbd snap create image --snap image-snap1

#      rbd snap ls image
#      SNAPID NAME            SIZE 
#      4 image-snap1 15360 MB

#    3) 删除客户端写入的测试文件

#      rm  -rf   /mnt/test.txt

#    4) 还原快照

#      rbd snap rollback image --snap image-snap1

#   客户端重新挂载分区

#      umount  /mnt
#      mount /dev/rbd0 /mnt/
#      ls  /mnt
    
#     创建快照克隆
#     
#     1）克隆快照

#      rbd snap protect image --snap image-snap1a   //unprotect

#      rbd snap rm image --snap image-snap1    //会失败

#      rbd clone image --snap image-snap1 image-clone --image-feature layering

#      //使用image的快照image-snap1克隆一个新的image-clone镜像

#     2）查看克隆镜像与父镜像快照的关系

#       rbd info image-clone

#       rbd image 'image-clone':
#         size 15360 MB in 3840 objects
#         order 22 (4096 kB objects)
#         block_name_prefix: rbd_data.d3f53d1b58ba
#         format: 2
#         features: layering
#         flags: 
#         parent: rbd/image@image-snap1

#     克隆镜像很多数据都来自于快照链


#     如果希望克隆镜像可以独立工作，就需要将父快照中的数据，全部拷贝一份，但比较耗时！！！

#       rbd flatten image-clone
#       rbd info image-clone

#         rbd image 'image-clone':
#         size 15360 MB in 3840 objects
#         order 22 (4096 kB objects)
#         block_name_prefix: rbd_data.d3f53d1b58ba
#         format: 2
#         features: layering
#         flags: 

#     #注意，父快照信息没了！

#    其他操作
#     
#     1） 客户端撤销磁盘映射

#      umount /mnt
#      rbd showmapped

#       id pool image        snap device    
#       0  rbd  image        -    /dev/rbd0

#      语法格式:

#      rbd unmap /dev/rbd/{poolname}/{imagename}
#      rbd unmap /dev/rbd/rbd/image

#     2）删除快照与镜像

#      rbd  snap rm image --snap image-snap

#      rbd  list

#      rbd  rm  image
}

#cr_mom
cr_osd
#yyRBD





