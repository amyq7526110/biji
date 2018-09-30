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


#            集群

#            bind IP地址                            //只写物理接口IP地址
#            daemonize yes                          //守护进程方式运行
#            port xxxx                              //端口号不要使用默认的6379
#            cluster-enabled yes                    //启用集群
#            cluster-config-file nodes-xxxx.conf    //指定集群信息文件
#            cluster-node-timeout 5000              //请求超时 5 秒

    
    ip=`ifconfig    | awk '/inet/{print $2}' | head -1`

    port=63${ip##*.}

            sed  -i '/^bind/s/127.0.0.1/'$ip'/'  $conf

            sed  -i '/^port /s/6379/'${port}'/'  $conf 

#            sed -ri '/^# cluster-en/s/# c/c/'    $conf

#            sed -ri '/^# cluster-con/s/# c(.*nodes-)(.*)/c\1'$port'.conf/' $conf

#            sed -ri '/^# cluster-node/s/# c(.*)15000/c\15000/'          $conf
 

#       修改脚本

            sed  -ri  '/-p/s/-p(.*)/-h '$ip' -p '$port'  shutdown/' /etc/init.d/redis_6379

#           sed -ri '/REDISPORT/s/6379/6345/' /etc/init.d/redis_6379       
 

#       重新启动

          /etc/init.d/redis_6379  stop
   
          /etc/init.d/redis_6379  start


          ln -n /etc/init.d/redis_6379  /bin/
}

rejc(){

cd ~

rupm=ruby-devel-2.0.0.648-30.el7.x86_64.rpm  

ruge=redis-3.2.1.gem

         [  !  -f   $rupm   ] &&  echo "don't have $rupm" && exit

  
         [  !  -f   $ruge   ] &&  echo "don't have $ruge" && exit

   
         yum -y install ruby rubygems

         rpm -ivh --nodeps $rupm

         gem install $ruge

         mkdir /root/bin/   
 
         cp redis-4.0.8/src/redis-trib.rb  /root/bin/
 
#        redis-trib.rb create --replicas 1 \
#            192.168.4.51:6351 192.168.4.52:6352 \
#            192.168.4.53:6353 192.168.4.54:6354 \
#            192.168.4.55:6355 192.168.4.56:6356 \    
     


}
rezc(){

    #            永久配置

#            主 192.168.4.51
#            vim /etc/redis/6379.conf
#            requirepass 123456

#            从 192.168.4.52
#            vim /etc/redis/6379.conf
#            slaveof  192.168.4.51 6351
#            masterauth  123456

#            从 192.168.4.53
#            vim /etc/redis/6379.conf
#            slaveof  192.168.4.52 6352
    

   read -p "请输入master 的 ip 和 端口 如：192.168.4.52 6352："  ip port 

   read -p "请输入master 的 密码 如果没有则 放弃输入 ：" passwd

   conf=/etc/redis/6379.conf

   sed -ri 's/^# (slaveof).*/\1  '$ip' '$port'/'  $conf


   if  [  -n   $passwd   ]

   then

       sed -ri 's/^# (masterauth).*/\1  '$passwd'/'  $conf
   
   fi
    
   redis_6379 restart


}

sentinel(){

     cd  ~

     redis_dir=redis-4.0.8/

     E_XCD=65

     [  ! -d $redis_dir  ] && echo "没有redis-4.0.8/目录" && exit $E_XCD

     
     read -p "请输入master 的 ip 和 端口 如：192.168.4.52 6352："  ip port 

     read -p "请输入master 的 密码 如果没有则 放弃输入 ：" passwd

     sefile=sentinel.conf
   
     cp   $redis_dir/$sefile   /etc/redis/

     seconf=/etc/redis/sentinel.conf

     masname=masterhost

     sed -i 's/mymaster/masterhost/'  $seconf 

     sed -i '/^sentinel mon/s/127.0.0.1 6379/'$ip' '$port'/'  $seconf
      
     if [  -n $passwd ]  

     then 

     sed -ri 's/(sentinel auth-pass).*/\1 masterhost 123456/' $seconf 

     fi

     redis-sentinel  $seconf

}


redis


