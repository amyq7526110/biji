#!/bin/bash 
mylnmp(){
#       安装 lnmp 环境  
 
#       安装部署 Nginx Mariadb Php Php-fem

#       判断是否有yum 源
  
        yum=`yum repolist  | awk -F:  '/repolist/{print $2}' |  sed 's/ //;s/,//'`       

        [  $yum  -le  0    ] && echo "you don't have  yum " && exit 1


#       安装依赖包               

        yum -y install gcc openssl-devel pcre-devel

        

#

        ln=lnmp_soft.tar.gz
   
        ng=nginx-1.12.2.tar.gz

#       安装  Nginx

        cd ~
     
#       判断家目录文件夹下是否有 lnmp_soft.tar.gz

        [  !  -f  $ln   ] && echo "you don't have lnmp_soft.tar.gz"  && exit 2

#       源码安装  Nginx

        useradd -s /sbin/nologin  nginx 
      
        tar -xf $ln

        cd lnmp_soft/

        yum -y install ./php-fpm-5.4.16-42.el7.x86_64.rpm

        tar -xf $ng

        cd  nginx-1.12.2/

#       修改 服务器名

        newname=Apache
        sed -i  '49s/nginx/Apache/'  src/http/ngx_http_header_filter_module.c
        sed -i  '50s/: /: Apache/;50s/NGINX_VER//'  src/http/ngx_http_header_filter_module.c
        sed -i  '51s/: /: Apache/;51s/NGINX_VER_BUILD//'  src/http/ngx_http_header_filter_module.c
        sed  -ri  '13,14s#"(.*)"#"Apache"#'  src/core/nginx.h
        sed -i  '36s/nginx/Apache/' src/http/ngx_http_special_response.c

#        ./configure 安装模块
   
#        --prefix=/usr/local/nginx       \\ 指定安装路径
#        --user=nginx                    \\ 指定用户
#        --group=nginx                   \\ 指定组
#        --with-http_ssl_module          \\ 开启SSL加密功能
#        --with-stream                   \\ 开启TCP/UDP代理模块
#        --with-http_stub_status_module       \\ 开启status状态页面
#        --without_http_autoindex_module \\ 禁用自动索引文件目录模块
#        --without_http_ssi_module       \\ 禁用ssi模块
 

        ./configure    \
        --prefix=/usr/local/nginx   \
        --user=nginx                \
        --group=nginx               \
        --with-http_ssl_module      \
        --with-stream               \
        --with-http_stub_status_module   \
        --without-http_autoindex_module \
        --without-http_ssi_module 
   
        make && make install 

#       创建 快捷方式   

        ln -s /usr/local/nginx/sbin/nginx /sbin
 

#       安装 mairadb php 环境

#        yum -y install mariadb-server mariadb mariadb-devel
        yum -y install php php-mysql


#      修改配置文件
  
       conf="/usr/local/nginx/conf/nginx.conf" 

        sed  -i   '65,71s/^.*#/        /'  $conf
        sed  -i   '70s/_.*$/.conf;/'       $conf
        sed  -i   '69d'                    $conf
        sed -rie ":begin; /^ +location/,/index.html/ { /index.html/! { $! { N; b begin }; }; s/index.html/index.php  index.html/ ; };" $conf


#       启动服务
                 
#        systemctl restart mariadb

#        systemctl enable mariadb

        systemctl restart php-fpm.service

        systemctl enable php-fpm

        nginx

        echo "/usr/local/nginx/sbin/nginx"  >> /etc/rc.local

        chmod +x /etc/rc.local
#      验证
  
       cp  ../php_scripts/mysql.php  /usr/local/nginx/html/

       sed -rie '/^\$mysql/s/root(.*)mysql/root\x27,\x27Azsd1234.\x27,\x27mysql/'  /usr/local/nginx/html/mysql.php
 
       firefox 127.0.0.1/mysql.php

}
#      优化

#      优化并发数 
myyh(){
       ngcf="/usr/local/nginx/conf/nginx.conf"

       sed -i  '/worker_connections/s/1024/65535/'   $ngcf

       sed -i '$a  * soft nofile 65535' /etc/security/limits.conf
       sed -i '$a  * hard nofile 65535' /etc/security/limits.conf 

#      增加数据包头部缓存大小 
   
       http_num=`awk '/^http/{print NR}'  $ngcf    `       
 
       let anum=http_num+2

       sed -i ''$anum'a   large_client_header_buffers 4 4k;'    $ngcf

       sed -i ''$anum'a   client_header_buffer_size  1k;'      $ngcf
   
       sed -i  's/^l/    l/'  $ngcf
  
       sed -i  's/^c/    c/'  $ngcf

#      定义对静态页面的缓存时间
 
       ser_num=`awk   '/^ +server /{print NR}'  $ngcf `               
       
       let  snum=ser_num+2

       sed -i ''$snum'a  }'  $ngcf
       sed -i ''$snum'a  expires        30d;'  $ngcf
       sed -i ''$snum'a location ~* \.(jpg|jpeg|gif|png|css|js|ico|xml)$ {'  $ngcf

       sed -i  's/^l/        l/'  $ngcf
       sed -i  's/^e/        e/'  $ngcf
       sed -i  's/^}/        }/'  $ngcf

#      定义状态页面
  
       sed -i  ''$snum'a   }' $ngcf
       sed -i  ''$snum'a   stub_status on;' $ngcf
       sed -i  ''$snum'a   location /status {' $ngcf
  
       sed -i  's/^l/        l/'  $ngcf
       sed -i  's/^s/        s/'  $ngcf
       sed -i  's/^}/        }/'  $ngcf

#      对页面进行压缩处理
#      gzip on;                            //开启压缩
#      gzip_min_length 1000;                //小文件不压缩
#      gzip_comp_level 4;                //压缩比率
#      gzip_types text/plain text/css application/json application/x-javascript text/xml application/xml application/xml+rss text/javascript;
#                                          //对特定文件压缩，类型参考mime.types

        gnum=`awk '/gzip /{print NR}' $ngcf`

        sed  -i  '/gzip/s/#//'  $ngcf

        sed  -i  ''$gnum'a \
    gzip_min_length 1000;  \
    gzip_comp_level 4;             \
    gzip_types text/plain text/css application/json application/x-javascript text/xml application/xml application/xml+rss text/javascript; '  $ngcf
 

#       服务器内存缓存


        sed  -i ''$anum'a  \
   open_file_cache          max=2000  inactive=20s; \
        open_file_cache_valid    60s; \
        open_file_cache_min_uses 5; \
        open_file_cache_errors   off; '  $ngcf

#    //设置服务器最大缓存2000个文件句柄，关闭20秒内无请求的文件句柄
#    //文件句柄的有效时间是60秒，60秒后过期
#    //只有访问次数超过5次会被缓存
}

mylnmp
myyh
nginx -s reload
