#!/bin/bash
read -p "Input your ipaddress and ethernet :" ip  wk
read -p "Input your want add ethernet and ip:"  eth  ipad
read -p "Input your hostname:"  name
read -p "Input your yum address:" yum
if [  "$ip" != ""  -a  "$wk" !=  ""     ];then
nmcli connection modify "$wk" ipv4.method manual ipv4.address "$ip"/24 connection.autoconnect yes
nmcli connection up "$wk"  
fi
if [  "$eth" != ""  -a  "$ipad" !=  ""     ];then
nmcli connection add type ethernet ifname "$eth" con-name $eth
nmcli connection modify "$eth" ipv4.method manual ipv4.address "$ipad"/24 connection.autoconnect yes
nmcli connection up "$eth"  
fi
if [   "$name"  != ""    ];then
hostnamectl set-hostname $name
fi
if [   "$yum"    != ""   ];then
rm -rf /etc/yum.repos.d/*
yum-config-manager --add $yum
echo "gpgcheck=0"  >>  /etc/yum.repos.d/`echo $yum |  sed  -r   's/.*\/+(.*)\//\1_/'`.repo
fi
