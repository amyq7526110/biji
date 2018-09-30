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


#                mycat介绍软件介绍

#                • mycat 是基于Java的分布式数据库系统中间层,为高并发环境的分布式访问提供解决方案

#                – 支持JDBC形式连接
#                – 支持MySQL、Oracle、Sqlserver、Mongodb等
#                – 提供数据读写分离服务
#                – 可以实现数据库服务器的高可用
#                – 提供数据分片服务
#                – 基于阿里巴巴Cobar进行研发的开源软件
#                – 适合数据大量写入数据的存储需求分片规则

#              • mycat支持提供10种分片规则

#                1 枚举法 sharding-by-intfile
#                2 固定分片 rule1
#                3 范围约定 auto-sharding-long
#                4 求模法 mod-long
#                5 日期列分区法 sharding-by-date
#                6 通配取模 sharding-by-pattern
#                7 ASCII码求模通配 sharding-by-prefixpattern
#                8 编程指定 sharding-by-substring
#                9 字符串拆分hash解析 sharding-by-stringhash
#                10 一致性hash sharding-by-murmur



