#!/bin/bash


    
    #  安装软件依赖包

    cd ~

    yum -y install readline-devel ncurses-devel

    cd lnmp_soft/

    yum -y install ./python-docutils-0.11-0.2.20130715svn7687.el7.noarch.rpm

    tar -xf varnish-5.2.1.tar.gz

    cd varnish-5.2.1

    ./configure

     make && make install

     cp  etc/example.vcl   /usr/local/etc/default.vcl

     sed  -i  '/\.host/s/127.0.0.1/192.168.2.100/' /usr/local/etc/default.vcl

     sed  -i  '/\.port/s/8080/80/' /usr/local/etc/default.vcl


     varnishd  -f /usr/local/etc/default.vcl

#    varnishd命令的其他选项说明如下：
#    varnishd –s malloc,128M        定义varnish使用内存作为缓存，空间为128M
#    varnishd –s file,/var/lib/varnish_storage.bin,1G 定义varnish使用文件作为缓存



#     1）查看varnish日志

#      varnishlog                        //varnish日志
#      varnishncsa                       //访问日志

#     2）更新缓存数据，在后台web服务器更新页面内容后，用户访问代理服务器看到的还是之前的数据，说明缓存中的数据过期了需要更新（默认也会自动更新，但非实时更新）。

#      varnishadm  
#      varnish> ban req.url ~ .*        //清空缓存数据，支持正则表达式



