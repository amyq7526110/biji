#!/bin/bash


   #  装包
haproxy_4(){


#  开启路由转发
  
     sed -i '/ip_forward/s/0/1/'  /etc/sysctl.conf  

     sysctl -p

     yum -y install haproxy

     cfg=/etc/haproxy/haproxy.cfg

     cp $cfg{,.bak} 

  #  注释 default 内容 后面的行   

     sed -rie ":begin; /^fro/,/5004/ { /5004/! { $! { N; b begin }; }; s/\n/\n#/g;s/^/#/; };"   $cfg

  #   haproxy web 访问页面路径
  
     sed -rie '/maxconn(.*)3000/a\   stats uri /admin'  $cfg

  #   
     bip=192.168.4.5

     sed -rie '/^stats/a  listen weblb '$bip':80' $cfg

     ip=(192.168.2.100 192.168.2.200 192.168.2.150 192.168.2.50)
  
     jsq=0
     
     ben=(weba webb webc webd)

     x=0

     for i in ${ip[@]}
     
     do 

         let "jsq++"

         sed -rie '/^listen/a\   server '${ben[x]}' '$i':80 cookie applinst'$jsq' check inter 2000 rise 2 fall 5'       $cfg

	 let "x++"

     done 	 

     sed -ri '/^listen/a\   balance roundrobin'   $cfg

     sed -ri '/^listen/a\   cookie SERVERID rewrite'   $cfg


     systemctl restart haproxy

   
     systemctl enable haproxy

}
haproxy_7(){

     yum -y install haproxy
   
     cfg=/etc/haproxy/haproxy.cfg

     cp $cfg{,.bak} 

     bip=192.168.4.5

     ip=(192.168.2.100 192.168.2.200 192.168.2.150 192.168.2.50)

     ben=(weba webb webc webd)


     sed -ri '/maxconn(.*)3000/a\    stats uri   /admin'  $cfg

     sed -ri '/^frontend/s/main(.*)/weblb '$bip':80/' $cfg

     sed -ri '/path_beg/s/(.*)/#/'  $cfg

     sed -ri '/path_end/s/(.*)url_static(.*)-i(.*)/\1url_html\2-i .html\n\1url_php\2-i .php/'  $cfg

     sed -ri '/use_backend/s/(.*)static(.*)static/\1htmlgrp\2html\n\1phpgrp\2php/'   $cfg

     sed -ri  '/default_backend/s/app/htmlgrp/'   $cfg


     sed -rie ":begin; /round /,/5004/ { /5004/! { $! { N; b begin }; }; s/\n/\n#/g;s/^/#/; };"   $cfg

 
     sed -ri  '/^backend/s/static/htmlgrp/'   $cfg

     sed -ri  '/server(.*)4331/s/(.*)static(.*)/\1weba 192.168.2.100:80 check\n\1webb 192.168.2.200:80 check/' $cfg

      sed -rie ":begin; /^backend/,/200:80 check/ { /200:80 check/! { $! { N; b begin }; }; s/(.*)html(.*)/\1php\2\n\1html\2/; };"   $cfg  

      sed -rie ":begin; /^backend/,/backend h/ { /backend h/! { $! { N; b begin }; }; s/weba 192.168.2.100/webc 192.168.2.50/; };"   $cfg

      sed -rie ":begin; /^backend/,/backend h/ { /backend h/! { $! { N; b begin }; }; s/webb 192.168.2.200/webd 192.168.2.150/; };"   $cfg




}

#haproxy_4
haproxy_7






#    配置文件说明

#         global

#          log 127.0.0.1 local2         ### [err warning info debug]
#          chroot /usr/local/haproxy
#          pidfile /var/run/haproxy.pid ### haproxy的pid存放路径
#          maxconn 4000                 ### 最大连接数，默认4000
#          user haproxy
#          group haproxy
#          daemon                       ###创建1个进程进入deamon模式运行
#          defaults 
#          mode http    ###默认的模式mode { tcp|http|health } 
#          log global   ###采用全局定义的日志
#          option dontlognull  ###不记录健康检查的日志信息
#          option httpclose  ###每次请求完毕后主动关闭http通道
#          option httplog   ###日志类别http日志格式
#          option forwardfor  ###后端服务器可以从Http Header中获得客户端ip
#          option redispatch  ###serverid服务器挂掉后强制定向到其他健康服务器
#          timeout connect 10000 #如果backend没有指定，默认为10s
#          timeout client 300000 ###客户端连接超时
#          timeout server 300000 ###服务器连接超时
#          maxconn  60000  ###最大连接数
#          retries  3   ###3次连接失败就认为服务不可用，也可以通过后面设置
#         listen stats
#             bind 0.0.0.0:1080   #监听端口
#             stats refresh 30s   #统计页面自动刷新时间
#             stats uri /stats   #统计页面url
#             stats realm Haproxy Manager #统计页面密码框上提示文本
#             stats auth admin:admin  #统计页面用户名和密码设置
#           #stats hide-version   #隐藏统计页面上HAProxy的版本信息



#      访问状态监控页的内容。
#      
#      备注：
#      Queue队列数据的信息（当前队列数量，最大值，队列限制数量）；
#      Session rate每秒会话率（当前值，最大值，限制数量）；
#      Sessions总会话量（当前值，最大值，总量，Lbtot: total number of times a server was selected选中一台服务器所用的总时间）；
#      Bytes（入站、出站流量）；
#      Denied（拒绝请求、拒绝回应）；
#      Errors（错误请求、错误连接、错误回应）；
#      Warnings（重新尝试警告retry、重新连接redispatches）；
#      Server(状态、最后检查的时间（多久前执行的最后一次检查）、权重、备份服务器数量、down机服务器数量、down机时长)。

