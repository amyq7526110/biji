#!/bin/bash

redis(){ 
    # 判断 root 下 是否有 Redis tar包 

    cd ~    

    re=redis-4.0.8.tar.gz

    [ ! -f $re ] && echo "没有$re" && exit 1

    #编译安装

    yum -y install gcc
 
    tar -xf   $re

   cd redis-4.0.8

    make && make  install 
 
    yum -y install expect    

      expect <<EOF
      
      spawn  utils/install_server.sh
      
      expect "Please"      {send "\n"}
      expect "Please"      {send "\n"}
      expect "Please"      {send "\n"}
      expect "Please"      {send "\n"}
      expect "Please"      {send "\n"}
      expect "ok"          {send "\n"}
      expect "#"            {send "exit\n"}

EOF
  
     conf=/etc/redis/6379.conf

#            常用配置选项

#            – port 6379                       //端口
#            – bind 127.0.0.1                  //IP地址
#            – tcp-backlog 511                 //tcp连接总数
#            – timeout 0                       //连接超时时间
#            – tcp-keepalive 300               //长连接时间
#            – daemonize yes                   //守护进程方式运行
#            – databases 16                    //数据库个数
#            – logfile /var/log/redis_6379.log //日志文件
#            – maxclients 10000                //并发连接数量
#            – dir /var/lib/redis/6379         //数据库目录内存管理

#            • 内存清除策略

#            – volatile-lru                //最近最少使用 (针对设置了TTL的key)
#            – allkeys-lru                 //删除最少使用的key
#            – volatile-random             //在设置了TTL的key里随机移除
#            – allkeys-random              //随机移除key
#            – volatile-ttl (minor TTL)    //移除最近过期的key
#            – noeviction                  //不删除,写满时报错内存管理(续1)

#            • 选项默认设置

#            – maxmemory <bytes>           //最大内存
#            – maxmemory-policy noeviction //定义使用策略
#            – maxmemory-samples 5         //个数 (针对lru 和 ttl 策略)

    
     ip=`ifconfig    | awk '/inet/{print $2}' | head -1`

     port=63${ip##*.}

     sed  -i  '/^bind/s/127.0.0.1/'$ip'/'  $conf

     sed -i '/^port /s/6379/'${port}'/'   $conf 
  

#       修改脚本

      sed  -i  '/-p/s/-p(.*)/-h '$ip' -p '$port'  shutdown/' /etc/init.d/redis_6379

      sed -ri '/REDISPORT/s/6379/6345/' /etc/init.d/redis_6379       
 

#       重新启动

     /etc/init.d/redis_6379  stop
   
     /etc/init.d/redis_6379  start
}


redis
