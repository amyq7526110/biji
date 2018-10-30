#!/bin/bash

#yum -y install bind-utils

#yum -y install lvm2

#vgcreate cinder-volumes /dev/vdb

#yum install -y qemu-kvm libvirt-client libvirt-daemon libvirt-daemon-driver-qemu python-setuptools

#yum -y install openstack-packstack

#packstack --gen-answer-file answer.ini

#sed  -ri '/AULT_PASS/s/=(.*)/=Taren1/' answer.ini
#sed  -ri '/SWIFT_IN/s/=(.*)/=n/' answer.ini
#sed  -ri '/NTP_SER/s/=(.*)/=192.168.1.254/' answer.ini
#sed  -ri '/LUMES_CRE/s/=(.*)/=n/' answer.ini
#sed  -ri '/TYPE_DRIVERS/s/=(.*)/=flat,\1/' answer.ini 
#sed  -ri '/VXLAN_GROUP/s/=(.*)/=239.1.1.5/' answer.ini 
#sed  -ri '/BRIDGE_MAP/s/=(.*)/=physnet1:br-ex/' answer.ini
#sed  -ri '/BRIDGE_IFACES/s/=(.*)/=br-ex:eth0/' answer.ini
#sed  -ri '/TUNNEL_IF/s/=(.*)/=eth1/' answer.ini 
#sed  -ri '/PROVISION_DEMO=y/s/=(.*)/=n/' answer.ini

    getenforce 
    rpm -qa | grep firewalld
    rpm -qa | grep NetM
    awk '/static/{print}' /etc/sysconfig/network-scripts/ifcfg-eth1
    awk '/static/{print}' /etc/sysconfig/network-scripts/ifcfg-eth0
    chronyc sources -v  | grep gateway
    dig -t A www.baidu.com | grep -i server

#    packstack --answer-file  answer.ini

sed -i '$a WSGIApplicationGroup %{GLOBAL}'  /etc/httpd/conf.d/15-horizon_vhost.conf 

apachectl graceful
