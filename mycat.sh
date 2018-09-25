#!/bin/bash

mycat=Mycat-server-1.4-beta-20150604171601-linux.tar.gz


       # 客户端 需要建立db1，db2 数据库  和 root@'%'  密码Azsd1234.


        cd ~

        [  ! -f $mycat ] && echo "root下没有mycat包" && exit 1

        tar -xf  $mycat 
   
        mv   mycat  /usr/local/

        cd /usr/local/mycat             
          
        sed  -i '/password/s/test/123456/'  conf/server.xml
       
        sed  -i '/password/s/user/123456/'  conf/server.xml

        sed  -i  '/dn3/s/,dn3//' conf/schema.xml

        sed -ri  '/<dataNode(.*)db3(.*)/s/(.*)/<!--\1-->/'  conf/schema.xml

        sed  -i '/db2/s/localhost1/localhost2/' conf/schema.xml

        sed -rie ":begin; /<writeHost(.*)hostS1/,/\/>$/ { /\/>$/! { $! { N; b begin }; }; s/(.*)/<\!--\1-->/; };"   conf/schema.xml

        sed -rie ":begin; /<dataHost/,/<\/dataHost>$/ { /<\/dataHost>$/! { $! { N; b begin }; }; s/(.*)/\1\n\1/; };"   conf/schema.xml

        sed -re ":begin; /<writeHost/,/heartbeat>$/ { /heartbeat>$/! { $! { N; b begin }; }; s/localhost/192.168.4.54/; };"   conf/schema.xml

        sed -rie ":begin; /<dataHost/,/<dataHost/ { /<dataHost/! { $! { N; b begin }; }; s/localhost:/192.168.4.54:/; };"   conf/schema.xml

        sed -rie ":begin; /<dataHost/,/<\/dataHost>$/ { /<\/dataHost>$/! { $! { N; b begin }; }; s/password=\"123456\"/password=\"Azsd1234.\"/; };"   conf/schema.xml

        sed -rie ":begin; /<\/dataHost>$/,/192.168.4.55/ { /192.168.4.55/! { $! { N; b begin }; }; s/localhost1/localhost2/; };"   conf/schema.xml

        sed -rie ":begin; /<\/dataHost>$/,/192.168.4.55/ { /192.168.4.55/! { $! { N; b begin }; }; s/hostM1/hostM2/; };"   conf/schema.xml
