#!/bin/bash


   #  装包

   yum -y install haproxy


   sed -rie ":begin; /^fro/,/5004/ { /5004/! { $! { N; b begin }; }; s/\n/\n#/g;s/^/#/; };" /etc/haproxy/haproxy.cfg

   sed -ri '/maxconn(.*)3000/a   listen weblb 192.168.4.58:80'  /etc/haproxy/haproxy.cfg 

   sed -ri '/maxconn(.*)3000/a   stats uri  /admin'  /etc/haproxy/haproxy.cfg 

   sed -ri '/^listen/a       server  webb 192.168.4.57:80 cookie applinst2 check inter 2000 rise 2 fall 5'  /etc/haproxy/haproxy.cfg

   sed -ri '/^listen/a       server  weba 192.168.4.55:80 cookie applinst1 check inter 2000 rise 2 fall 5'  /etc/haproxy/haproxy.cfg

   sed -ri '/^listen/a       balance roundrobin'  /etc/haproxy/haproxy.cfg

   sed -ri '/^listen/a       cookie SERVERID rewrite'  /etc/haproxy/haproxy.cfg


