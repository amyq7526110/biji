#!/bin/bash 
#
my(){
  
   echo   
   echo -e "\033[31m $1 \033[0m"
   echo 
  
   mysql -e "$1"
      
} 
#   ----------------------NoSQL-day15 MongoDB副本集 -------------------------------


#           MongoDB副本集

#           环境准备

#           副本集介绍

#           也称为MongoDB复制

#             – 指在多个服务器上存储数据副本,并实现数据同步

#             – 提高数据可用性、安全性,方便数据故障恢复


#           MongoDB复制原理

#           副本集工作过程

#           – 至少需要两个节点。其中一个是主节点,负责处理客
#             户端请求,其余是从节点,负责复制主节点数据

#           – 常见搭配方式:一主一从、一主多从

#           – 主节点记录所有操作oplog,从节点定期轮询主节点获
#             取这些操作,然后对自己的数据副本执行这些操作,
#             从而保证从节点的数据与主节点一致副本集实现方式
#             副本集实现方式

#           MongoDB副本集

#           Master-Slave 主从复制

#           – 启动一台服务器时加上“-master”参数,作为主节点

#           – 启动其他服务器时加上“-slave”和“-source”参数,作为从节点

#           主从复制的优点

#           – 从节点可以提供数据查询,降低主节点的访问压力

#           – 由从节点执行备份,避免锁定主节点数据

#           – 当主节点故障时,可快速切换到从节点,实现高可用


#           副本集实现方式(续1)

#           Replica Sets副本集

#           – 从1.6 版本开始支持,优于之前的replication

#           – 支持故障自动切换、自动修复成员节点,降低运维成本

#           – Replica Sets副本集的结构类似高可用集群


#           配置Replica Sets

#           运行MongoDB服务

#           配置节点信息

#           初始化Replica Sets环境

#           查看副本集信息

#           验证副本集配置环境准备副本集介绍

#           Replica Sets

#           运行MongoDB服务
#           • 启动服务时,指定主机所在副本集名称
#           – 所有副本集成员使用相同的副本集名称

#           – --replSet rs1           //指定副本集名称

#           mkdir -p /data/db

#           ./mongod --bind_ip 192.168.4.61 \
#           --logpath=/var/log/mongod.log --replSet rs1 &配置节点信息

#           sed -i '$a replSet=rs1' /usr/local/mongodb/etc/mongodb.conf      


#           • 在任意一台主机连接mongod服务,执行如下操作

#           ./mongo --host 192.168.4.51  --port 27051

#           config = {
#           _id:"rs1",
#           members:[
#           {_id:0,host:"IP地址:端口"},
#           {_id:1,host:"IP地址:端口"},
#           {_id:2,host:"IP地址:端口"}
#           ]
#           }

   
#           config = {
#           _id:"rs1",
#           members:[
#           {_id:0,host:"192.168.4.51:27051"},
#           {_id:1,host:"192.168.4.52:27052"},
#           {_id:2,host:"192.168.4.53:27053"}   
#           ]
#           }




#           初始化Replica Sets环境

#           • 执行如下命令

#           – > rs.initiate(config)

#           • 查看状态信息

#           – > rs.status( )

#           • 查看是否是master库

#           – > rs .isMaster( )验证副本集配置

#           • 同步数据验证,允许从库查看数据

#           – >db.getMongo( ).setSlaveOk( )

#           • 自动切换主库验证

#           – > rs.isMaster( )

#           – 验证副本集配置

#           MongoDB文档管理
#           插入文档
#           save()

#           • 格式
#            > db.集合名.save({ key:“值”,key:”值”})

#           • 注意

#           – 集合不存在时创建集合,然后再插入记录

#           – _id字段值已存在时,修改文档字段值

#           – _id字段值不存在时,插入文档

#            insert()

#           • 格式

#           > db.集合名.insert({key:"值",key:"值"})

#           • 注意

#           – 集合不存在时创建集合,然后再插入记录

#           – _id字段值已存在时,放弃插入

#           – _id字段值不存在时,插入文档insert()(续1)

#           insert()

#           • 插入多条记录

#              > db.集合名.insertMany(
#              [
#              {name:"xiaojiu",age:19} ,
#              {name:"laoshi",email:"yaya@tedu.cn"}
#              ]


#           查询文档

#           查询语法

#           • 显示所有行(默认输出20行,输入it可显示后续行)

#                > db.集合名.find()

#           • 显示第1行

#                > db.集合名.findOne()

#           • 指定查询条件并指定显示的字段

#                > db.集合名.find({条件},{定义显示的字段})
#                > db.user.find({},{_id:0,name:1,shell:1})
#                //0 不显示,1 显示

#            行数显示限制

#           • limit(数字)    //显示前几行

#                db.集合名.find().limit(3)

#                 db.user.find({},{_id:0,name:1,shell:1}).limit(3)

#		 { "name" : "bob", "shell" : "/bin/bash" }
#		 { "name" : "root", "shell" : "/bin/bash" }
#		 { "name" : "bin", "shell" : "/sbin/nologin" }

#		  db.user.find({shell:"/sbin/nologin"},{_id:0,name:1,shell:1}).limit(3)

#		 { "name" : "bin", "shell" : "/sbin/nologin" }
#		 { "name" : "daemon", "shell" : "/sbin/nologin" }
#		 { "name" : "adm", "shell" : "/sbin/nologin" }
		 
  
#           • count()        //统计个数

#                  > db.user.find({shell:"/sbin/nologin"}).count()
#		   36

#		   > db.user.find().count()
#		   42
#

#           • skip(数字)     //跳过前几行

#                db.集合名.find().skip(2)

#                db.user.find({shell:"/bin/bash"},{_id:0,name:1}).skip()
#		 { "name" : "bob" }
#		 { "name" : "root" }
#		 { "name" : "lisi" }

#	         db.user.find({shell:"/bin/bash"},{_id:0,name:1}).skip(2)
#		 { "name" : "lisi" }



#           • sort(字段名)   //1升序,-1降序

#               db.集合名.find().sort({age:1|-1})

#               db.user.find({shell:"/bin/bash"},{_id:0,name:1,uid:1}).sort({uid:1})
#		{ "name" : "root", "uid" : 0 }
#		{ "name" : "lisi", "uid" : 1000 }
#		{ "name" : "bob", "uid" : 2000 }

#	        db.user.find({shell:"/bin/bash"},{_id:0,name:1,uid:1}).sort({uid:-1})
#		{ "name" : "bob", "uid" : 2000 }
#		{ "name" : "lisi", "uid" : 1000 }
#		{ "name" : "root", "uid" : 0 }

           
#           db.user.find({shell:"/sbin/nologin"},{_id:0,name:1,uid:1,shell:1}).skip(2).limit(2)


#           匹配条件

#           • 简单条件

#            db.集合名.find({key:"值"})
#            db.集合名.find({key:"值",keyname:"值"})
#            db.user.find({shell:"/bin/bash"})
#            db.user.find({shell:"/bin/bash",name:"root"})

#            db.user.find({name:"bin"},{_id:0,name:1})
#	     { "name" : "bin" }

#	     db.user.find({name:"bin"},{_id:0,name:1,uid:1})
#	     { "name" : "bin", "uid" : 1 }
	     



#           匹配条件(续1)

#           • 范围比较

#           – $in 在...里
#           – $nin 不在...里
#           – $or 或
#           > db.user.find({uid:{$in:[1,6,9]}})
#           > db.user.find({uid:{$nin:[1,6,9]}})
#           > db.user.find({$or: [{name:"root"},{uid:1} ]})

#             db.user.find({uid:{$in:[1,2,99]}},{_id:0,comment:0,gid:0,homedir:0})
#	      { "name" : "bin", "password" : "x", "uid" : 1, "shell" : "/sbin/nologin" }
#	      { "name" : "daemon", "password" : "x", "uid" : 2, "shell" : "/sbin/nologin" }
#	      { "name" : "nobody", "password" : "x", "uid" : 99, "shell" : "/sbin/nologin" }
#             db.user.find({shell:{$nin:["/bin/bash","/sbin/nologin"]}},{_id:0,comment:0,gid:0,homedir:0,password:0})
#	      { "name" : "sync", "uid" : 5, "shell" : "/bin/sync" }
#	      { "name" : "shutdown", "uid" : 6, "shell" : "/sbin/shutdown" }
#	      { "name" : "halt", "uid" : 7, "shell" : "/sbin/halt" }


#             db.user.find({$or:[{uid:1},{name:"root"}]},{_id:0,uid:1,name:1})
#             { "name" : "root", "uid" : 0 }
#             { "name" : "bin", "uid" : 1 }



#           匹配条件(续2)
#           • 正则匹配

#              > db.user.find({name: /^a/ })

#              > db.user.find({name:/a/},{_id:0,name:1,shell:1})
#		 { "name" : "daemon", "shell" : "/sbin/nologin" }
#		 { "name" : "adm", "shell" : "/sbin/nologin" }
#		 { "name" : "halt", "shell" : "/sbin/halt" }
#
#              > db.user.find({name:/^...$/},{_id:0,name:1})
#		 { "name" : "bob" }
#		 { "name" : "bin" }
#		 { "name" : "adm" }
#		 { "name" : "ftp" }

 
  

#           • 数值比较

#             – $lt $lte $gt $gte $ne

#             – <   <=    >   >=   !=    
       
#            db.user.find({uid:{$lt:5}},{_id:0,name:1,uid:1})
#		{ "name" : "root", "uid" : 0 }
#		{ "name" : "bin", "uid" : 1 }
#		{ "name" : "daemon", "uid" : 2 }
#		{ "name" : "adm", "uid" : 3 }
#		{ "name" : "lp", "uid" : 4 }

#            db.user.find({uid:{$lt:3}},{_id:0,name:1,uid:1})
#               { "name" : "root", "uid" : 0 }
#	        {     { "name" : "bin", "uid" : 1 }
#	        {     { "name" : "daemon", "uid" : 2 }

#	     db.user.find({uid:{$lte:3}},{_id:0,name:1,uid:1})
#	        { "name" : "root", "uid" : 0 }
#	        { "name" : "bin", "uid" : 1 }
#	        { "name" : "daemon", "uid" : 2 }
#	        { "name" : "adm", "uid" : 3 }

#            db.user.find( { uid: { $gte:10,$lte:40} } , {_id:0,name:1,uid:1})

#            db.user.find({uid:{$lte:5}})

#          并且

#            db.user.find({name:"root",uid:0},{_id:0,name:1,uid:1})
#            { "name" : "root", "uid" : 0 }

#            db.user.find({uid:{$gte:10,$lte:20}},{_id:0,name:1,uid:1})
#            { "name" : "operator", "uid" : 11 }
#            { "name" : "games", "uid" : 12 }
#            { "name" : "ftp", "uid" : 14 }



#           匹配条件(续3)

#           • 匹配null ,也可以匹配没有的字段

#          > db.user.save({name:null,uid:null})

#          > db.user.find({name:null})

#          > db.user.find({"_id":
#             ObjectId("5afd0ddbd42772e7e458fc75"),"name" : null, "uid" :
#             null })
          
#	   > db.c4.save({name:null})

#	   > db.c4.save({name:null,age:null})

#	   > db.c4.find({name:null},{_id:0})
#	     { "name" : null }
#	     { "name" : null, "age" : null }

#          > db.c4.save({shell:"/bin/bash",age:18})

#          > db.c4.find({name:null},{_id:0})
#	     { "name" : null }
#	     { "name" : null, "age" : null }
#	     { "shell" : "/bin/bash", "age" : 18 }


#          > db.c4.save({shell:"/bin/bash",uid:18})

#          > db.c4.find({name:null,uid:null},{_id:0})
#	     { "name" : null }
#	     { "name" : null, "age" : null }
#	     { "shell" : "/bin/bash", "age" : 18 }
           
#        查询语法

#          更新文档

#           update()

#           • 语法格式

#           > db.集合名.update({条件},{修改的字段})
   
#           > db.user2.find({uid:{$lte:4}},{_id:0,name:1,uid:1})
#           { "name" : "root", "uid" : 0 }
#           { "name" : "bin", "uid" : 1 }
#           { "name" : "daemon", "uid" : 2 }
#           { "name" : "adm", "uid" : 3 }
#           { "name" : "lp", "uid" : 4 }

#           > db.user2.update({uid:{$lt:4}},{password:"AAA"})

#           > db.user2.find({uid:{$lte:4}},{_id:0,name:1,uid:1})
#           { "name" : "bin", "uid" : 1 }
#           { "name" : "daemon", "uid" : 2 }
#           { "name" : "adm", "uid" : 3 }
#           { "name" : "lp", "uid" : 4 }

#           > db.user2.find({password:"AAA"})
#           { "_id" : ObjectId("5bb0632af68f02fadba9a85d"), "password" : "AAA" }

#           注意  把文档的其他字段都删除了,只留下了password字段,
#                 且只修改与条件匹配的第1行!!!




#           多文档更新

#           • 语法格式:默认只更新与条件匹配的第1行

#           > db.user.update({条件},{$set:{修改的字段}}) //默认只更新与条件匹配的第1行

#           > db.user.update({条件},{$set:{修改的字段}} ,false,true)

#           > db.user.update({name:"bin"},{$set:{password:"abc12123"}},false,true)


#           > db.user2.find({uid:{$gte:5,$lte:10}},{_id:0,name:1,uid:1,password:1})
#	    { "name" : "sync", "password" : "x", "uid" : 5 }
#	    { "name" : "shutdown", "password" : "x", "uid" : 6 }
#	    { "name" : "halt", "password" : "x", "uid" : 7 }
#	    { "name" : "mail", "password" : "x", "uid" : 8 }

#	    > db.user2.update({uid:{$gte:5,$lte:10}},{$set:{password:"ABC"}})

#	    > db.user2.find({uid:{$gte:5,$lte:10}},{_id:0,name:1,uid:1,password:1})
#	    { "name" : "sync", "password" : "ABC", "uid" : 5 }
#	    { "name" : "shutdown", "password" : "x", "uid" : 6 }
#	    { "name" : "halt", "password" : "x", "uid" : 7 }
#	    { "name" : "mail", "password" : "x", "uid" : 8 }

#	    > db.user2.find({uid:{$gte:5,$lte:10}},{_id:0,name:1,uid:1,password:1},false,true)
#	    { "name" : "sync", "password" : "ABC", "uid" : 5 }
#	    { "name" : "shutdown", "password" : "x", "uid" : 6 }
#	    { "name" : "halt", "password" : "x", "uid" : 7 }
#	    { "name" : "mail", "password" : "x", "uid" : 8 }

#	    > db.user2.update({uid:{$gte:5,$lte:10}},{$set:{password:"ABC"}},false,true)

#	    > db.user2.find({uid:{$gte:5,$lte:10}},{_id:0,name:1,uid:1,password:1})
#	    { "name" : "sync", "password" : "ABC", "uid" : 5 }
#	    { "name" : "shutdown", "password" : "ABC", "uid" : 6 }
#	    { "name" : "halt", "password" : "ABC", "uid" : 7 }
#	    { "name" : "mail", "password" : "ABC", "uid" : 8 }


#           $set/$unset
#           $inc
#           $push/$addToSet
#           $pop/$pull
#           删除文档
#           drop()/remove()插入文档save()
#           )


#           $set/$unset

#           • $set 条件匹配时,修改指定字段的值

#           > db.user.update({条件},$set: {修改的字段})
#           > db.user3.update({name:"bin"},{$set:{password:"A"}})

#           • $unset 删除与条件匹配文档的字段

#           > db.集合名.update({条件},{$unset:{key:values}})
#           > db.user3.update({name:"bin"},{$unset:{password:"A"}})

#              > db.user2.find({name:"bin"})
#     { "_id" : ObjectId("5bb0632af68f02fadba9a85e"), "name" : "bin", "password" : "x", "uid" : 1, "gid" : 1, "comment" : "bin", "homedir" : "/bin", "shell" : "/sbin/nologin" }


#	      > db.user2.update({name:"bin"},{$unset:{password:"x"}})

#	      > db.user2.find({name:"bin"})

#	      { "_id" : ObjectId("5bb0632af68f02fadba9a85e"), "name" : "bin", "uid" : 1, "gid" : 1, "comment" : "bin", "homedir" : "/bin", "shell" : "/sbin/nologin" }




#           $inc

#           • $inc 条件匹配时,字段值自加或自减

#           > db.集合名.update({条件},{$inc:{字段名:数字}})

#           > db.user.update({name:"bin"},{$inc:{uid:2}})     //字段值自加2
#           > db.user.update({name:“bin”},{$inc:{uid:-1}})    //字段值自减1

#           > db.user2.find({name:"bin"})
#	    { "name" : "bin", "uid" : 1 }

#	    > db.user2.update({name:"bin"},{$inc:{uid:2}})

#	    > db.user2.find({name:"bin"},{_id:0,name:1,uid:1})
#	    { "name" : "bin", "uid" : 3 }

#           > db.user2.update({name:"bin"},{$inc:{uid:-1}})

#	    > db.user2.find({name:"bin"},{_id:0,name:1,uid:1})
#	     { "name" : "bin", "uid" : 2 }




#           +num 自增,-num 自减


#           $push/$addToSet

#           • $push 向数组中添加新元素

#           > db.集合名.update({条件},{$push:{数组名:"值"}})

#           > db.user.insert({name:"bob",likes:["a","b","c","d","e","f"]})

#           > db.user.update({name:“bob”},{$push:{likes:“w"}})


#           > db.user.insert({name:"bob",likes:["a","b","c","d","e","f"]})

#	    > db.user.find({name:"bob"},{_id:0})

#	    {  "name" : "bob", "likes" : [ "a", "b", "c", "d", "e", "f" ] }

#           > db.user.update({name:"bob"},{$push:{likes:"haha"}})

#           > db.user.find({name:"bob"},{_id:0})
#           { "name" : "bob", "password" : "x", "uid" : 2000, "gid" : 2000, "comment" : "  ", "homedir" : "/home/bob", "shell" : "/bin/bash", "likes" : [ "haha" ] }
#           { "name" : "bob", "likes" : [ "a", "b", "c", "d", "e", "f" ] }

#           > db.user.update({name:"bob"},{$push:{likes:"haha"}},false,true)

#           > db.user.update({name:"bob"},{$push:{likes:"xixi"}},false,true)

#           > db.user.find({name:"bob"},{_id:0})
#           { "name" : "bob", "password" : "x", "uid" : 2000, "gid" : 2000, "comment" : "  ", "homedir" : "/home/bob", "shell" : "/bin/bash", "likes" : [ "haha", "haha", "xixi" ] }
#           { "name" : "bob", "likes" : [ "a", "b", "c", "d", "e", "f", "haha", "xixi" ] }
#           > 


#           • $addToSet 避免重复添加

#           > db.集合名.update({条件},{$addToSet:{数组名:"值"}})

#           > db.user.update({name:"bob"},{$addToSet:{likes:"f"}})
    
#           > db.user.update({name:"bob"},{$addToSet:{likes:"xixi"}},false,true)

#           > db.user.find({name:"bob"},{_id:0})
#           { "name" : "bob", "password" : "x", "uid" : 2000, "gid" : 2000, "comment" : "  ", "homedir" : "/home/bob", "shell" : "/bin/bash", "likes" : [ "haha", "haha", "xixi" ] }
#           { "name" : "bob", "likes" : [ "a", "b", "c", "d", "e", "f", "haha", "xixi" ] }






#            $pop/$pull

#           • $pop 从数组头部删除一个元素


#           > db.集合名.update({条件},{$pop:{数组名:数字}})

#           > db.user.update({name:"bob"},{$pop:{likes:1}})           1 删除数组尾部元素
#           > db.user.update({name:"bob"},{$pop:{likes:-1}})         -1 删除数组头部元素

#           > db.user.update({name:"bob"},{$pop:{likes:1}},false,true)

#           > db.user.find({name:"bob"},{_id:0})
#           { "name" : "bob", "password" : "x", "uid" : 2000, "gid" : 2000, "comment" : "  ", "homedir" : "/home/bob", "shell" : "/bin/bash", "likes" : [ "haha", "haha" ] }
#           { "name" : "bob", "likes" : [ "a", "b", "c", "d", "e", "f", "haha" ] }

#           > db.user.update({name:"bob"},{$pop:{likes:-1}},false,true)

#           > db.user.find({name:"bob"},{_id:0})
#	     { "name" : "bob", "password" : "x", "uid" : 2000, "gid" : 2000, "comment" : "  ", "homedir" : "/home/bob", "shell" : "/bin/bash", "likes" : [ "haha" ] }
#	     { "name" : "bob", "likes" : [ "b", "c", "d", "e", "f", "haha" ] }





#           • $pull 删除数组指定元素

#           > db.集合名.update({条件},{$pull:{数组名:值}})

#           > db.user.update({name:"bob"},{$pull:{likes:"b"}})

#           > db.user.update({name:"bob"},{$pull:{likes:"haha"}},false,true)

#           > db.user.find({name:"bob"},{_id:0})
#           { "name" : "bob", "password" : "x", "uid" : 2000, "gid" : 2000, "comment" : "  ", "homedir" : "/home/bob", "shell" : "/bin/bash", "likes" : [ ] }
#           { "name" : "bob", "likes" : [ "b", "c", "d", "e", "f" ] }


#           > db.user.update({name:"bob"},{$push:{likes:"f"}},false,true)

#           > db.user.find({name:"bob"},{_id:0})
#           { "name" : "bob", "password" : "x", "uid" : 2000, "gid" : 2000, "comment" : "  ", "homedir" : "/home/bob", "shell" : "/bin/bash", "likes" : [ "f" ] }
#           { "name" : "bob", "likes" : [ "b", "c", "d", "e", "f", "f" ] }

#           > db.user.update({name:"bob"},{$pull:{likes:"f"}},false,true)

#           > db.user.find({name:"bob"},{_id:0})
#           { "name" : "bob", "password" : "x", "uid" : 2000, "gid" : 2000, "comment" : "  ", "homedir" : "/home/bob", "shell" : "/bin/bash", "likes" : [ ] }
#           { "name" : "bob", "likes" : [ "b", "c", "d", "e" ] }



#           删除文档$drop/$remove

#           • $drop 删除集合的同时删除索引

#           > db.集合名.drop( )
#           > db.user.drop( )

#           • $remove() 删除文档时不删除索引

#           > db.集合名.remove({})          //删除所有文档
#           > db.集合名.remove({条件})      //删除与条件匹配的文档
#           > db.user.remove({uid:{$lte:10}})
#           > db.user.remove({})


#           > db.user2.find({password:"ABC"},{_id:0,name:1,password:1})
#           { "name" : "sync", "password" : "ABC" }
#           { "name" : "shutdown", "password" : "ABC" }
#           { "name" : "halt", "password" : "ABC" }
#           { "name" : "mail", "password" : "ABC" }

#           > db.user2.remove({password:"ABC"})

#           > db.user2.find({password:"ABC"}).count()
#           0



#           总结和答疑

#       更新命令总结

#           类 型       用 途
#           $set        修改文档指定字段的值
#           $unset      删除记录中的字段
#           $push       向数组内添加新元素
#           $pull       删除数组中的指定元素
#           $pop        删除数组头尾部元素
#           $addToSet   避免数组重复赋值
#           $inc        字段自加或自减
#           
#      


#   ---------------------------------------------------------------------------------
#   ----------------------NoSQL-day14 部署MongoDB服务 -------------------------------
#                NoSQL数据库管理

#                MongoDB概述

#                MongoDB介绍

#                相关概念

#                部署MongoDB服务
#                搭建MDB服务器
#                安装软件
#                创建配置文件
#                启动服务
#                连接服务MongoDB概述MongoDB介绍
#                • 介于关系数据库和非关系数据库之间的产品
#                – 一款基于分布式文件存储的数据库,旨在为WEB应用
#                提供可扩展的高性能数据存储解决方案
#                – 将数据存储为一个文档(类似于JSON对象),数据结
#                构由键值(key=>value)对组成
#                – 支持丰富的查询表达,可以设置任何属性的索引
#                – 支持副本集,分片相关概念
#                • 免安装,解压后即可使用
#                [root@bogon ~]# mkdir /usr/local/mongodb
#                [root@bogon ~]# tar -zxf mongodb-linux-x86_64-rhel70-3.6.3.tgz
#                [root@bogon ~]# cp -r mongodb-linux-x86_64-rhel70-3.6.3/bin
#                /usr/local/mongodb/
#                [root@bogon ~]# cd /usr/local/mongodb/
#                [root@bogon mongodb]# mkdir -p etc log data/db创建配置文件
#                • 手动创建服务主配置文件
#                [root@bogon ~]# vim mongodb.conf
#                logpath=/usr/local/mongodb/log/mongodb.log
#                logappend=true
#                //追加的方式记录日志信息
#                dbpath=/usr/local/mongodb/data/db
#                //数据库目录
#                fork=true
#                //守护进程方式运行启动服务
#                • 启动服务
#                # ./bin/mongod -f /usr/local/mongodb/etc/mongodb.conf
#                • 查看进程
#                # ps -C mongod
#                • 查看端口
#                # netstat -utnlp | grep :27017连接服务
#                • 本地连接,默认没有密码
#                [root@bogon ~]# /usr/local/mongodb/bin/mongo
#                MongoDB shell version v3.6.3
#                connecting to: mongodb://127.0.0.1:27017
#                MongoDB server version: 3.6.3
#                .. ..
#                > show dbs
#                //显示已有的库
#                admin 0.000GB
#                config 0.000GB
#                local 0.000GB
#                > exit
#                //断开连接
#                bye
#                [root@bogon ~]#案例1:搭建MongoDB服务器
#                满足以下要求:
#                – 在主机192.168.4.51上部署MongoDB服务
#                MongoDB基本使用
#                常用管理命令
#                数据库管理
#                集合管理
#                文档基本管理
#                MongoDB基本使用
#                基本数据类型
#                字符string/布尔bool/空null
#                数值/数组array
#                代码/日期/对象
#                内嵌/正则表达式
#                数据导入导出
#                数据导出
#                数据导入
#                数据备份与恢复
#                数据备份
#                数据恢复常用管理命令数据库管理
#                • 查看、创建、切换、 删除库
#                – show dbs //查看已有的库
#                – db //显示当前所在的库
#                – use 库名 //切换库,若库不存在延时创建库
#                – show collections 或 show tables //查看库下已有集合
#                – db.dropDatabase()
#                //删除当前所在的库数据库管理(续1)
#                • 数据库名称规范
#                – 不能是空字符串("")
#                – 不得含有' '(空格)、. 、$、/、\和\0 (空字符)
#                – 应全部小写
#                – 最多64字节集合管理
#                • 查看、创建、删除集合
#                – show collections 或 show tables
#                #查看集合
#                – db.集合名.drop() #删除集合
#                – db.集合名.save({'',''})
#                在时,创建并添加文档 #创建集合,集合不存
#                > db.user.save({'name':'bob','age':'21'})
#                WriteResult({ "nInserted" : 1 })集合管理(续1)
#                • 集合名命名规范
#                – 不能是空字符串""
#                – 不能含有\0字符(空字符),此字符表示集合的结尾
#                – 不能以“system.”开头,这是为系统集合保留的前缀
#                – 用户创建的集合名字不能含有保留字符文档基本管理
#                • 文档 : 类似于MySQL表里的记录
#                 文档基本管理(续1)
#                • 查看 、统计、添加 、删除文档
#                – db.集合名.find()
#                – db.集合名.count()
#                – db.集合名.insert({“name”:”jim”})
#                – db.集合名.find({条件})
#                – db.集合名.findOne() //返回一条文档
#                – db.集合名.remove({}) //删除所有文档
#                – db.集合名.remove({条件}) //删除匹配的所有文档文档管理(续2)
#                • 插入记录
#                > db.col.insert(
#                { title: 'MongoDB 教程',
#                description: 'MongoDB 是一个 Nosql 数据库',
#                by: 'MongoDB中文网',
#                url: 'http://www.mongodb.org.cn',
#                tags: ['mongodb', 'database', 'NoSQL'],
#                likes: 100
#                }
#                )
#                > db.col.remove({‘title’:‘MongoDB 教程’})
#                //删除记录

#                案例2:MongoDB常用管理操作
#                要求如下:
#                – 练习库的创建、查看、切换、删除
#                – 练习集合的创建、查看、删除
#                – 练习文档的查看、插入、删除

#                  基本数据类型字符s

#                  tring/布尔bool/空null

#                • 字符串string

#                – UTF-8字符串都可以表示为字符串类型的数据

#                – {name:"张三"} 或 { school:"tarena"}

#                • 布尔bool

#                – 布尔类型有两个值true和false,{x:true}

#                • 空null
#                – 用于表示空值或者不存在的字段,{x:null}数值/数组array

#                • 数值

#                – shell默认使用64位浮点型数值。{x:3.14}或{x:3}。

#                – NumberInt(4字节整数){x:NumberInt(3)}
#                – NumberLong(8字节整数){x:NumberLong(3)}

#                • 数组array

#                – 数据列表或数据集可以表示为数组
#                – {x: ["a","b", "c"]}代码/日期/对象

#                • 代码

#                – 查询和文档中可以包括任何JavaScript代码
#                – {x: function( ){/* 代码 */}}

#                • 日期

#                – 日期被存储为自新纪元以来经过的毫秒数,不含时区
#                – {x:new Date( )}

#                • 对象

#                – 对象id是一个12字节的字符串,是文档的唯一标识
#                – {x: ObjectId() }内嵌/正则表达式

#                • 内嵌

#                – 文档可以嵌套其他文档,被嵌套的文档作为值来处理
#                – {tarena:
#                {address:"Beijing",tel:"888888",person:"hansy" }}

#                • 正则表达式

#                – 查询时,使用正则表达式作为限定条件
#                – {x:/正则表达式/}数据导入导出数据导出

#                • 语法格式1
#                # mongoexport [--host IP地址 --port 端口 ] \
#                -d 库名 -c 集合名 -f 字段名1,字段名2 \
#                --type=csv > 目录名/文件名.csv
#                • 语法格式2
#                # mongoexport --host IP地址 --port 端口 \
#                -库名 -c 集合名 -q '{条件}' -f 字段名1,字段名2 \
#                --type=csv > 目录名/文件名.csv
#                注意:导出为csv格式必须使用-f 指定字段名列表!!!数据导出(续1)
#                • 语法格式3
#                # mongoexport [ --host IP地址 --port 端口 ] \
#                -d 库名 -c 集合名 [ -q ‘{ 条件 }’ –f 字段列表 ] \
#                --type=json > 目录名/文件名.json数据导入
#                • 语法格式1
#                # mongoimport --host IP地址 --port 端口 \
#                -d 库名 –c 集合名 \
#                --type=json 目录名/文件名.json
#                • 语法格式2
#                # mongoimport --host IP地址 --port 端口 \
#                -d 库名 -c 集合名 \
#                --type=csv [--headerline] [--drop] 目录名/文件名.csv
#                1. 导入数据时,若库和集合不存在,则先创建库和集合后再导入数据;
#                2. 若库和集合已存在,则以追加的方式导入数据到集合里;
#                3. 使用--drop选项可以删除原数据后导入新数据,--headerline 忽略标题数据备份恢复数据备份
#                • 备份数据所有库到当前目录下的dump目录下
#                # mongodump [ --host ip地址 --port 端口 ]
#                • 备份时指定备份的库和备份目录
#                # mongodump [ --host ip地址 --port 端口 ] -d 数据库名 -c 集
#                合名 -o 目录
#                • 查看bson文件内容
#                # bsondump ./dump/bbs/t1.bson数据恢复
#                • 语法格式
#                # mongorestore --host IP地址 --port 端口 -d 数据库名 [ -c 集
#                合名 ] -o 备份目录名
#                案例3:数据导入导出/备份/恢复
#                要求如下:
#                – 练习数据导入导出
#                – 练习数据备份恢复总结和答疑
#                数据类型 Mongodb数据类型总结
#                数据导出 问题现象
#                总结和答疑
#                故障分析与排除数据类型数据类型总结
#                • mongodb数据类型总结
#                – 字符串类型
#                – 数值类型、布尔类型
#                – 空 /正则/代码
#                – 数组、数值、日期
#                – 对象
#                – 内嵌数据导出问题现象
#                • 数据导出为csv格式时报错
#                [root@host50 bin]# ./mongoexport -d mdb -c t1 --type=csv >
#                /root/t1.csv
#                2018-05-27T14:36:04.084+0800 Failed: CSV mode requires a
#                field list故障分析及排除
#                • 原因分析:
#                – csv格式导出数据时,必须指定导出的字段名
#                [root@host50 bin]# ./mongoexport -d mdb -c t1 -f
#                name,shell,uid --type=csv > /root/t1.csv



#   ---------------------------------------------------------------------------------------
#   ----------------------NoSQL-day13 Redis 主从复制 持久化 (RDB/AOF)数据类型 -------------


#            主从复制概述主从复制结构模式

#               • 结构模式

#               – 一主一从
#               master
#               slave

#               – 一主多从
#               master
#               slave
#               slave

#               – 主从从
#               master
#               slave
#               slave

#            主从复制工作原理

#            • 工作原理

#            – Slave 向 maste 发送 sync 命令
#            – Master 启动后台存盘进程,同时收集所有修改数据命
#            令
#            – Master 执行完后台存盘进程后,传送整个数据文件到
#            slave 。
#            – Slave 接收数据文件后,将其存盘并加载到内存中完成
#            首次完全同步
#            – 后续有新数据产生时, master 继续将新的所以收集到
#            的修改命令依次传给 slave ,完成同步。


#            主从复制缺点
#            • 缺点
#             
#            – 网络繁忙,会产生数据同步延时问题
#            – 系统繁忙,会产生数据同步延时问题


#            配置主从复制拓扑结构
#            • 主服务器数据自动同步到从服务器

#            Master 服务器  复制 / 同步 Slave 服务器
#            192.168.4.51/24            192.168.4.52/24
#            
#                                      Linux 客户机  
#                                      192.168.4.50/24
#            
#             配置从库

#             查看主库信息

#             192.168.4.51:6351> info replication 

#            • 配置从库 192.168.4.52/24

#              – redis 服务运行后,默认都是 master 服务器


#             redis-cli -h 192.168.4.52 -p 6352

#             192.168.4.52:6352> info replication // 查看主从配置信息
#             # Replication
#               role:master

#            命令行指定主库
#            SLAVEOF 主库 IP 地址 端口号

#            connected_slaves:0
#            ......
#            192.168.4.52:6352> SLAVEOF 192.168.4.51 6351
#            OK
#            192.168.4.52:6352> info replication
#            # Replication
#            role:slave

#            主从从

             
#            redis-cli -h 192.168.4.53 -p 6353

#            192.168.4.53:6353> SLAVEOF 192.168.4.52 6352
#            OK


#            192.168.4.53:6353> info replication
#            # Replication
#            role:slave

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





#            • 反客为主
#            – 主库宕机后,手动将从库设置为主库

#            redis-cli -h 192.168.4.53

#            192.168.4.53:6353> SLAVEOF no one // 设置为主库
#            OK

#            192.168.4.52:6379> info replication


#            • 哨兵模式

#            – 主库宕机后,从库自动升级为主库

#            – 在 slave 主机编辑 sentinel.conf 文件

#            – 在 slave 主机运行哨兵程序

#            vim /etc/sentinel.conf
#            sentinel monitor redis51 192.168.4.51 6351 1
#            sentinel auth-pass host51 123456

#            redis-sentinel /etc/sentinel.conf


#            sentinel myid ef35147c34ddbe77d1ca9036061e4ad5bfe00007
#            sentinel monitor host51 192.168.4.52 6352 1
#            port 26379
#            dir "/root"
#            sentinel auth-pass host51 123456
#            sentinel config-epoch host51 1
#            sentinel leader-epoch host51 1
#            sentinel known-slave host51 192.168.4.51 6351
#            sentinel known-slave host51 192.168.4.53 6353
#            sentinel current-epoch 1



 
#            sentinel monitor 主机名 ip 地址 端口 票数
#            主机名:自定义
#            IP 地址: master 主机的 IP 地址
#            端 口: master 主机 redis 服务使用的端口
#            票 数:主库宕机后, 票数大于 1 的主机被升级为主库配置带验证的主从复制
#            • 配置 master 主机
#            – 设置连接密码 ,启动服务,连接服务
#            [root@redis51 ~]# sed -n '70p;501p' /etc/redis/6379.conf
#            bind 192.168.4.51
#            requirepass 123456 // 密码
#            [root@redis51 ~]#
#            [root@redis51 ~]# /etc/init.d/redis_6379 start
#            Starting Redis server...
#            [root@redis51 ~]# redis-cli -h 192.168.1.111 -a 123456 -p 6379
#            192.168.4.51:6379>配置带验证的主从复制 ( 续 1 )
#            • 配置 slave 主机
#            – 指定主库 IP ,设置连接密码,启动服务
#            [root@redis52 ~]# sed -n '70p;282p;289p' /etc/redis/6379.conf
#            bind 192.168.4.52
#            slaveof 192.168.4.51 6379 // 主库 IP 与端口
#            masterauth 123456 // 主库密码
#            [root@redis52 ~]#
#            [root@redis52 ~]# /etc/init.d/redis_6379 start
#            Starting Redis server...
#            [root@redis52 ~]# redis-cli -h 192.168.4.52
#            192.168.4.52:6379> INFO replication
#            # Replication
#            role:slave
#            master_host:192.168.4.51
#            master_port:6379案例 1 :配置 redis 主从复制
#            具体要求如下:
#            – 将主机 192.168.4.52 配置主机 192.168.4.51 的从库




#----------------        持久化 RDB/AOF       --------------------------------------

#            持久化之 RDB

#            RDB 介绍

#            • 全称 Reids DataBase

#            – 数据持久化方式之一
#            – 在指定时间间隔内,将内存中的数据集快照写入硬盘
#            – 术语叫 Snapshot 快照。
#            – 恢复时,将快照文件直接读到内存里。


#           备份恢复redis

#                cp /var/lib/redis/6379/dump.rdb /root/
#                rm -rf /var/lib/redis/6379/dump.rdb
#                redis
#                redis_6379       redis-check-aof  redis-cli        redis-server     
#                redis-benchmark  redis-check-rdb  redis-sentinel   
#                dis_6379 restart
#                Stopping ...
#                Waiting for Redis to shutdown ...
#                Redis stopped
#                Starting Redis server...
#                ls /var/lib/redis/6379/dump.rdb 
#                redis-cli -h 192.168.4.50 -p 6350
#                192.168.4.50:6350> keys *
#                1) "name"
#                192.168.4.50:6350> get name
#                "boy"
#                192.168.4.50:6350> exit
#                [root@host50 ~]# redis_6379 stop
#                Stopping ...
#                Redis stopped
#                [root@host50 ~]# rm -rf /var/lib/redis/6379/dump.rdb
#                [root@host50 ~]# redis_6379 restart
#                /var/run/redis_6379.pid does not exist, process is not running
#                Starting Redis server...
#                [root@host50 ~]# redis-cli -h 192.168.4.50 -p 6350
#                192.168.4.50:6350> keys *
#                (empty list or set)
#                192.168.4.50:6350> exit
#                [root@host50 ~]# redis_6379 stop
#                Stopping ...
#                Redis stopped
#                cp /root/dump.rdb  /var/lib/redis/6379/
#                cp：是否覆盖"/var/lib/redis/6379/dump.rdb"？ y
#                redis_6379 restart
#                /var/run/redis_6379.pid does not exist, process is not running
#                Starting Redis server...
#                redis-cli -h 192.168.4.50 -p 6350
#                192.168.4.50:6350> keys *
#                1) "name"
#                192.168.4.50:6350> 



#            相关配置参数

#            • 文件名

#            – dbfilename dump.rdb  // 文件名

#            •  禁用 RDB

#            – save  "" 

#            •  数据从内存保存到硬盘的频率
#            
#            – save 900  1            // 900 秒内且有 1 次修改存盘
#            – save 60   10000        // 60  秒内且有 10000 修改存盘
#            – save 300  10           // 300 秒内且有 10 次修改存盘
#            
#            • 手动立刻存盘
#            
#            –    > save              // 阻塞写存盘
#            –    > bgsave            // 不阻塞写存盘相关配置参数 ( 续 1)

#            • 压缩

#            – rdbcompression yes | no

#            • 在存储快照后,使用 crc16 算法做数据校验

#            – rdbchecksum yes|no

#            • bgsave 出错停止写操作 , 对数据一致性要求不高设置为 no

#            – stop-writes-on-bgsave-error yes|no使用 RDB 文件恢复数据

#            Redis 持久化
#            RDB/AOF
#            持久化之 AOF
#            AOF 介绍
#            相关配置参数
#            使用 AOF 文件恢复数据
#            RDB 优点与缺点持久化之 RDBRDB 介绍
#            。
#            • 备份数据
#            使用 RDB 文件恢复数据
#            – 备份 dump.rdb 文件到其他位置
#            – ~]# cp 数据库目录 /dump.rdb
#            备份目录
#            • 恢复数据
#            – 把备份的 dump.rdb 文件拷贝回数据库目录 , 重启 red
#            is 服务
#            – cp 备份目录 /dump.rdb 数据库目录 /
#            – /etc/redid/redis_ 端口 startRDB 



#            RDB 优点与缺点

#            • RDB 优点
#            – 持久化时, Redis 服务会创建一个子进程来进行持久
#            化,会先将数据写入到一个临时文件中,待持久化过
#            程都结束了,再用这个临时文件替换上次持久化好的
#            文件;整个过程中主进程不做任何 IO 操作,这就确保
#            了极高的性能。
#            – 如果要进程大规模数据恢复,且对数据完整行要求不
#            是非常高,使用 RDB 比 AOF 更高效。

#            • RDB 的缺点

#            – 意外宕机,最后一次持久化的数据会丢失。



#            – 使用 RDB 文件恢复数据

#             持久化之 AOF

#             AOF 介绍

#            • 只追加操作的文件

#            – Append Only File
#            – 记录 redis 服务所有写操作。
#            – 不断的将新的写操作,追加到文件的末尾。
#            – 使用 cat 命令可以查看文件内容相关配置参数

#            • 文件名

#            – appendfilename "appendonly.aof" // 文件名

#            – appendonly yes // 启用 aof ,默认 no

#            • AOF 文件记录,写操作的三种方式

#            – appendfsync always  // 有新的写操作立即记录,性能差,完整性好。

#            – appendfsync everysec // 每秒记录一次,宕机时会丢失 1 秒的数据

#            – appendfsync no       // 从不记录相关配置参数 ( 续 1)

#            • 日志重写 ( 日志文件会不断增大 ) ,何时会触发日志重写?

#            – redis  会记录上次重写时 AOF 文件的大小,默认配置
#            是当aof文件是上次 rewrite 后大小的 1 倍且文件大于64M 时触发。

#            – auto-aof-rewrite-percentage 100 
#            – auto-aof-rewrite-min-size 64mb

#            数据库目录 /AOF 优点 / 缺点

#            • RDB 优点

#            – 可以灵活的设置同步持久化 appendfsync alwayls 或
#            异步持久化 appendfsync everysec

#            – 宕机时,仅可能丢失 1 秒的数据

#            • RDB 的缺点

#            – AOF 文件的体积通常会大于 RDB 文件的体积。执行 fs
#            ync 策略时的速度可能会比 RDB 慢。

#            – 把文件恢复时间长

#            • 修复 AOF 文件,

#            – 把文件恢复到最后一次的正确操作

#             cp /var/lib/redis/6379/appendonly.aof /root/

#             redis-cli -h 192.168.4.50 -p 6350

#             192.168.4.50:6350> flushall
#             OK

#             192.168.4.50:6350> keys *
#             (empty list or set)

#             192.168.4.50:6350> exit

#             redis_6379 stop
#             Stopping ...
#             Redis stopped
#             redis_6379 start
#             Starting Redis server...

#             redis-cli -h 192.168.4.50 -p 6350

#             192.168.4.50:6350> keys *
#             (empty list or set)

#             192.168.4.50:6350> exit

#             redis_6379 stop
#             Stopping ...
#             Redis stopped

#             cp appendonly.aof /var/lib/redis/6379/
#             cp：是否覆盖"/var/lib/redis/6379/appendonly.aof"？ y

#             redis_6379 start
#             Starting Redis server...

#             redis-cli -h 192.168.4.50 -p 6350

#             192.168.4.50:6350> keys *
#             1) "sex"
#             2) "age"
#             3) "name"

#    ---------------        数据类型     ----------------------------------

#            String 字符串 字符串操作

#            List 列表 List 列表简介
              
#            set 集合
#             
#            List 列表操作
#            Hash 表
#            Hash 表简介
#            Hash 表操作String 


#             字符串字符串操作

#            • set key value [ex seconds] [px milliseconds] [nx|xx]

#            – 设置 key 及值

#            — ex,px 过期时间可以设置为秒或毫秒为单位

#            – nx 只有 key 不存在,才对 key 进行操作

#            – xx 只有 key 已存在,才对 key 进行操作

#            set name pop nx
#            (nil)

#            set name pop xx
#            OK

#            set haha pop xx
#            (nil)


#            • setrange key offset value

#            – 从偏移量开始复写 key 的特定位的值

#             set first "hello world"

#             setrange first 6 "Redis"  // 改写为 hello Redis

#             set tel 1233113333
#             OK

#             get tel
#             "1233113333"

#             SETRANGE tel 3 ****
#             (integer) 10

#             get tel
#             "123****333"






#            • strlen key

#            – 统计字串长度

#               strlen name
#               (integer) 3

#            • append key value

#            – 字符存在则追加,不存在则创建 key 及 value

#            – 返回值为 key 的长度

#             append myname jacob

#            • setbit key offset value

#            – 对 key 所存储字串,设置或清除特定偏移量上的位 (bit)

#            – Value 值可以为 1 或 0 , offset 为 0~2^32 之间

#            – key 不存在,则创建新 key

#            >setbit bit 0 1
#            >setbit bit 1 0

#            bit: 第 0 位为 1 ,第一位为 0字符串操作(续 2 )

#            • bitcount key
#            – 统计字串中被设置为 1 的比特位数量

#            >setbit bits 0 1 //0001
#            
#            >setbit bits 3 1 //1001
#            
#            >bitcount bits   //结果为 2
#            
#            记录网站用户上线频率,如用户 A 上线了多少天等类似的数据
#            如用户在某天上线,则使用 setbit ,以用户名为 key ,将网站上线
#            日为 offset ,并在该 offset 上设置 1 ,最后计算用户总上线次数时
#            ,使用 bitcount 用户名即可
#            这样,即使网站运行 10 年,每个用户仅占用 10*365 比特位即 456
#            字节即可
#            >setbit peter 100 1 // 网站上线 100 天用户登录了一次

#            >setbit peter 105 1 // 网站上线 105 天用户登录了一次

#            >bitcount peter字符串操作(续 3 )

#            • decr key
#            – 将 key 中的值减 1 , key 不存在则先初始化为 0 ,再减 1

#            set test 10
#            decr test
#            • decrby key decrement
#            – 将 key 中的值,减去 decrement
#            set count 100
#            decrby count 20
#            • get key
#            – 返回 key 所存储的字符串值
#            – 如果 key 不存在则返回特殊值 nil
#            – 如果 key 的值不是字串,则返回错误, get 只能处理字串字符串操作(续 4 )
#            • getrange key start end
#            – 返回字串值中的子字串,截取范围为 start 和 end
#            – 负数偏移量表述从末尾计数, -1 表示最后一个字符, -2
#            表示倒数第二个字符
#            set first “hello,the world”
#            getrange first -5 -1
#            getrange first 0 4字符串操作(续 5 )
#            • incr key
#            – 将 key 的值加 1 ,如果 key 不存在,则初始为 0 后再加 1
#            – 主要应用为计数器
#            >set page 20
#            >incr page
#            • incrby key increment
#            – 将 key 的值增加 increment字符串操作(续 6 )
#            • incrbyfloat key increment
#            – 为 key 中所储存的值加上浮点数增量 increment
#            >set num 16.1
#            >incrbyfloat num 1.1
#            • mget key [key...]
#            – 一次获取一个或多个 key 的值,空格分隔, < 具有原子性
#            >
#            • mset key value [key value ...]
#            – 一次设置多个 key 及值,空格分隔, < 具有原子性 >



#            Hash 表Hash 表简介
#            • Redis hash 是一个 string 类型的 field 和 value 的映
#            射表
#            • 一个 key 可对应多个 field ,一个 field 对应一个 valu
#            e
#            • 将一个对象存储为 hash 类型,较于每个字段都存储成
#            string 类型更能节省内存Hash 表操作
#            • hset key field value
#            – 将 hash 表中 field 值设置为 value
#            >hset site google 'www.g.cn‘
#            >hset site baidu 'www.baidu.com'
#            • hget key filed
#            – 获取 hash 表中 field 的值
#            >hget site googleHash 表操作(续 1 )
#            • hmset key field value [field value...]
#            – 同时给 hash 表中的多个 field 赋值
#            >hmset site google www.g.cn baidu www.baidu.com
#            • hmget key field [field...]
#            – 返回 hash 表中多个 field 的值
#            >hmget site google baidu
#            • hkeys key
#            – 返回 hash 表中所有 field 名称
#            >hmset site google www.g.cn baidu www.baidu.com
#            >hkeys siteHash 表操作(续 2 )
#            • hgetall key
#            – 返回 hash 表中所有 field 的值
#            • hvals key
#            – 返回 hash 表中所有 filed 的值
#            >hvals key
#            • hdel key field [field...]
#            – 删除 hash 表中多个 field 的值,不存在则忽略
#            >hdel site google baiduList 

#             列表List 列表简介

#              • Redis 的 list 是一个字符队列
 
#              • 先进后出

#              • 一个 key 可以有多个值List

#             列表操作

#            • lpush key value [value...]

#                 – 将一个或多个值 value 插入到列表 key 的表头

#                 – Key 不存在,则创建 key

#             >lpush list a b c //list1 值依次为 c b a等同于 lpush list a; lpush list b; lpush list c


#            • lrange key start stop

#                – 从开始位置读取 key 的值到 stop 结束

#                >lrange list 0 2  // 从 0 位开始,读到 2 位为止
#                >lrange list 0 -1 // 从开始读到结束为止
#                >lrange list 0 -2 // 从开始读到倒数第 2 位值List 列表操作(续 1 )
            
#            • lpop key

#                – 移除并返回列表头元素数据, key 不存在则返回 nil

#                >lpop list   // 删除表头元素,可以多次执行
#            • llen key

#                – 返回列表 key 的长度List 列表操作(续 2 )

#            • lindex key index

#                – 返回列表中第 index 个值

#            如 lindex key 0 ; lindex key 2; lindex key -2
#            • lset key index value
#            – 将 key 中 index 位置的值修改为 value
#            >lset list 3 test
#            // 将 list 中第 3 个值修改为 testList 列表操作(续 3 )
#                – 返回列表中第 index 个值

#            如 lindex key 0 ; lindex key 2; lindex key -2
#            • lset key index value
#            – 将 key 中 index 位置的值修改为 value
#            >lset list 3 test
#            // 将 list 中第 3 个值修改为 testList 列表操作(续 3 )
#                – 返回列表中第 index 个值

#            如 lindex key 0 ; lindex key 2; lindex key -2
#            • lset key index value
#            – 将 key 中 index 位置的值修改为 value
#            >lset list 3 test
#            // 将 list 中第 3 个值修改为 testList 列表操作(续 3 )
#            • rpush key value [value...]
#            – 将 value 插入到 key 的末尾
#            知
#            识
#            讲
#            解
#            >rpush list3 a b c
#            >rpush list3 d
#            //list3 值为 a b c
#            // 末尾插入 d
#            • rpop key
#            – 删除并返回 key 末尾的值
#            – >rpush list3 a b c //list3 值为 a b c
#            >rpush list3 d
#            // 末尾插入 d其他操作其他操作指令
#            • del key [key...]
#            – 删除一个或多个 key
#            知
#            识
#            讲
#            解
#            • exists key
#            – 测试一个 key 是否存在
#            • expire key seconds
#            – 设置 key 的生存周期
#            • persist key
#            – 设置 key 永不过期
#            • ttl key
#            – 查看 key 的生存周期其他操作指令(续 1 )
#            • keys 匹配
#            – 找符合匹配条件的 key ,特殊符号用 \ 屏蔽
#            知
#            识
#            讲
#            解
#            >keys *
#            // 显示所有 key
#            >keys h?llo // 匹配 hello,hallo,hxllo 等
#            >keys h*llo // 匹配 hllo 或 heeello 等
#            >keys h[ae]lo // 匹配 hello 和 hallo
#            • flushall
#            – 清空所有数据
#            • select id
#            – 选择数据库, id 用数字指定,默认数据库为 0
#            >select 0
#            >select 2其他操作指令(续 2 )
#            • move key db_id
#            – 将当前数据库的 key 移动到 db_id 数据库中
#            知
#            识
#            讲
#            解
#            >move key 1
#            // 将 key 移动到 1 数据库中
#            • rename key newkey
#            – 给 key 改名为 newkey , newkey 已存在时,则覆盖
#            其值
#            • renamenx key newkey
#            – 仅当 newkey 不存在时,才将 key 改名为 newkey其他操作指令(续 3 )
#            • sort key
#            – 对 key 进行排序
#            知
#            识
#            讲
#            解
#            >lpush cost 1 8 7 2 5
#            >sort cost
#            // 默认对数字排序,升序
#            >sort cost desc
#            // 降序
#            >lpush test “about” “site” “rename”
#            >sort test alpha
#            // 对字符排序
#            >sort cost alpha limit 0 3
#            // 排序后提取 0-3 位数据
#            >sort cost alpha limit 0 3 desc
#            >sort cost STORE cost2 // 对 cost 排序并保存为 cost2
#            • type key
#            – 返回 key 的数据类型案例 3 :常用 Redis 数据库操作指
#            令
#            • 对 Redis 数据库各数据类型进行增删改查操作
#            课
#            堂
#            练
#            习
#            – 数据类型分别为 Strings 、 Hash 表、 List 列表
#            – 设置数据缓存时间
#            – 清空所有数据
#            – 对数据库操作总结和答疑
#            数据类型 数据类型总结
#            管理命令 管理命令总结
#            总结和答疑数据类型数据类型总结
#            知
#            识
#            讲
#            解
#            • 字符类型
#            • hash 表类型
#            • List 列表类型管理命令管理命令总结
#            • del key [key...]
#            – 删除一个或多个 key
#            知
#            识
#            讲
#            解
#            • exists key
#            – 测试一个 key 是否存在
#            • expire key seconds
#            – 设置 key 的生存周期
#            • persist key
#            – 设置 key 永不过期
#            • ttl key
#            – 查看 key 的生存周期




# -------------------------------------------------------------------------------------


#   ----------------------NoSQL-day11 创建Redis集群 -----------------------------
#           redis 服务器 ip 地址及端口规划

#           192.168.4.51    6351
#           192.168.4.52    6352
#           192.168.4.53    6353
#           192.168.4.54    6354
#           192.168.4.55    6355
#           192.168.4.56    6356
#           
#           yum -y install gcc gcc-c++  ruby rubygems

#           tar -zxvf redis-3.2.0.tar.gz

#           cd redis-3.2.0/

#           make

#           make install PREFIX=/usr/loca/redis

#           mkdir /etc/redis

#           cp redis.conf  /etc/redis/

#           vim /etc/redis/redis.conf

#           bind  IP地址	                 //只写物理接口的IP地址

#           daemonize    yes                     //redis后台运行

#           port  xxxx                           //端口号不要使用默认的6379

#           cluster-enabled  yes                 //开启集群  把注释#去掉

#           cluster-config-file  nodes.conf      //集群的配置文件 不要使用默认的名称 

#           cluster-node-timeout  5000           //请求超时  设置5秒够了
#           
#           :wq
#           
#

#            创建集群

#               • 在选中的一台redis服务器上,执行创建集群脚本

#               – 部署ruby脚本运行环境

#               – 创建集群

#                yum -y install ruby rubygems

#                rpm -ivh --nodeps ruby-devel-2.0.0.648-30.el7.x86_64.rpm

#                gem install redis-3.2.1.gem

#                cd redis-4.0.8/src/

#                ./redis-trib.rb create --replicas 1 host:port host:port ......

#               --replicas 1 ,自动为每一个master节点分配一个slave节点创建集群(续1)

#               • 创建集群

#               redis-trib.rb create --replicas 1 \
#               192.168.4.51:6351 192.168.4.52:6352 \
#               192.168.4.53:6353 192.168.4.54:6354 \
#               192.168.4.55:6355 192.168.4.56:6356 \
#               >>> Creating cluster
#               >>> Performing hash slots allocation on 6 nodes...
#               Using 3 masters:
#               192.168.4.51:6351
#               192.168.4.52:6352
#               192.168.4.53:6353
#               ......
#               [OK] All nodes agree about slots configuration.
#               >>> Check for open slots...
#               >>> Check slots coverage...
#               [OK] All 16384 slots covered.
           
#           
#           集群创建成功后，会显示谁是主 谁是从。 和主从关系  及分配的槽数范围。redis-1   redis-2
#           
#            --replicas  1  表示 自动为每一个master节点分配一个slave节点  
#           
#           
#           #/usr/loca/redis/bin/redis-cli  -h
#           
#           在redis服务器上自己访问自己

#           #/usr/loca/redis/bin/redis-cli  -c  -p 端口

#           > cluster nodes   #查看本机信息  
#           > cluster info    #查看集群信息
#           
#           获取数据测试方法：在其中任意一台上存储数据 ，在其他任意一台上都可以获取数据。并且会提示从存到那台上了，和从那台上获取的数据

#           存数据  set  name  jerry
#           取数据  get   name
#           
#     工作过程

 



          
#           集群节点选取测试： 把是master 角色主机上的 Redis服务 停止，看对应是slave角色主机 是否能自动升级为master。原先是master服务启动后 身份是slave

#           redis-8  
#           redis-9
#           redis-10
#           redis-11
#           
#           二 添加新节点  

#           2.1 添加主节点： 装包 修改配置文件 启动服务 ； 
#               把主机192.168.2.93添加进集群 做主节点
#           
#           添加集群节点                                      新节点            任意写一个就可以

#            ./redis-trib.rb  add-node  192.168.2.93:6393  192.168.2.94:6394
#           
#           
#           检查时 发现主机93 是 M 状态 ，但没有分配槽位。

#            ./redis-trib.rb  check  192.168.2.93:6393 
#           
#           连接查看槽位信息 也是没有的

#           /usr/local/redis/bin/redis-cli -c -h 192.168.2.93  -p 6393 
#           192.168.2.93:6393> cluster nodes
#           
#           手动对集群进行重新分片迁移数据

#           ./redis-trib.rb  reshard 192.168.2.94:6394

#           How many slots do you want to move (from 1 to 16384)? 4096    （因为一共有4个主节点 想平均分配 16384/4=4096）
#           What is the receiving node ID? f6649ea99b2f01faca26217691222c17a3854381 此处输入93主机的ID 意思是给93主机分配4096个槽
#           Please enter all the source node IDs.
#             Type 'all' to use all the nodes as source nodes for the hash slots.
#             Type 'done' once you entered all the source nodes IDs.
#           Source node #1:all  意思是从所有主节点主机获取  也可以从某个主节点主机获取  出提示信息后输入yes 开始分配
#           
#           查看分配的槽位
#           ./redis-trib.rb  check 192.168.2.93:6393
#              slots:0-1364,5461-6826,10923-12287 (4096 slots) master       从3个主节点主机上获取的槽位数量
#           
#           登录后查看槽位信息

#           /usr/local/redis/bin/redis-cli -c -h 192.168.2.93  -p 6393 
#           
#           2.2 添加从节点

#           把主机192.168.2.92添加进集群 做从节点
#           装包  修改配置文件 启动redis服务，

#           yum -y  install  gcc gcc-c++  ruby  rubygems
#           tar -zxf redis-3.2.0.tar.gz
#           cd redis-3.2.0/
#           make
#           make install PREFIX=/usr/local/redis
#           cp redis.conf  /usr/local/redis/
#           vim /usr/local/redis/redis.conf
#           /usr/local/redis/bin/redis-server  /usr/local/redis/redis.conf
#           netstat -utnalp  | grep redis
#           systemctl  stop firewalld
#           setenforce 0
#           rpm -ivh --nodeps ruby-devel-2.0.0.648-30.el7.x86_64.rpm 
#           gem install redis-3.2.1.gem 
#           
#           添加从节点

#           # ./redis-trib.rb add-node --slave --master-id id值  192.168.2.92:6392 192.168.2.94:6394
#           如果不指定主节点的id 的话，会把新节点 随机添加为 从节点 最少的主的从。
#           
#            redis-3.2.0/src/redis-trib.rb  add-node --slave  192.168.2.92:6392  192.168.2.94:6394
#           
#           /usr/local/redis/bin/redis-cli -c -h 192.168.2.92 -p 6392

#           三、移除节点

#           3.1 移除主节点  把主节点192.168.2.93移除  ./redis-trib del-node  

#           redis-3.2.0/src/redis-trib.rb  check 192.168.2.94:6394

#           [ERR] Node 192.168.2.97:6397 is not empty! Reshard data away and try again.  提示不是空 不能移除 要先删除槽数。 才可以删除
#           
#           redis-3.2.0/src/redis-trib.rb reshard 192.168.2.94:6394

#           How many slots do you want to move (from 1 to 16384)? 4096  移除的槽数
#           What is the receiving node ID? 8eecda17577349125df9a6fcc37107c6c5f9bdc5 从那个节点上移除
#           Please enter all the source node IDs.
#             Type 'all' to use all the nodes as source nodes for the hash slots.
#             Type 'done' once you entered all the source nodes IDs.
#           Source node #1:f6649ea99b2f01faca26217691222c17a3854381  #移动到那个节点上
#           Source node #2:done  输入done
#           
#           Do you want to proceed with the proposed reshard plan (yes/no)? yes 输入yes
#           
#           查看

#           redis-3.2.0/src/redis-trib.rb check 192.168.2.94:6394
#              slots:0-6826,10923-12287 (8192 slots) master   有8192个槽位了
#              slots: (0 slots) master  没有槽位了

#           移除节点

#           redis-3.2.0/src/redis-trib.rb del-node 192.168.2.93:6393 f6649ea99b2f01faca26217691222c17a3854381

#           
#           查看信息  就会少一个主节点

#           redis-3.2.0/src/redis-trib.rb check 192.168.2.93:6393
#           [ERR] Sorry, can't connect to node 192.168.2.93:6393
#           
#           redis-3.2.0/src/redis-trib.rb check 192.168.2.97:6397

#           
#           3.2 移除从节点 从节点192.168.3.92 移除
#                                                    任意IP和端口都可以     
#           # redis-3.2.0/src/redis-trib.rb del-node 192.168.2.92:6392  被移除主机的ID
#           
#           redis-3.2.0/src/redis-trib.rb del-node 192.168.2.92:6392 9c507832f99b9af53563646a06c5b0525e8fcb4a





#               cluster reset






  
  






#   ----------------------------------------------------------------------------
#   ----------------------MYSQL-day11 NoSQL介绍  搭建Redis服务器-----------------
#       数据库类型RDBMS
#         • 关系数据库管理系统

#         – Relational Database Management System

#         – 按照预先设置的组织结构,将数据存储在物理介质上
#         – 数据之间可以做关联操作RDBMS服务软件

#         • 主流的RDBMS软件
#         – Oracle
#         – DB2
#         – MS SQL Server
#         – MySQL、MariaDBNoSQL

#         • NoSQL(NoSQL = Not Only SQL)

#         – 意思是“不仅仅是SQL”
#         – 泛指非关系型数据库
#         – 不需要预先定义数据存储结构
#         – 表的每条记录都可以有不同的类型和结构NoSQL服务软件

#         • 主流软件
#         – Redis
#         – MongoDB
#         – Memcached
#         – CouchDB
#         – Neo4j
#         – FlockDB

#       部署Redis服务Redis介绍

#            • Redis

#            – Remote Dictionary Server(远程字典服务器)
#            – 是一款高性能的(Key/Values)分布式内存数据库
#            – 支持数据持久化,可以把内存里据保存到硬盘中
#            – 也支持 list、hash、set、zset 数据类型
#            – 支持 master-salve 模式数据备份
#            – 中文网站www.redis.cn装包

#          • 从源码包 编译安装

#            tar -xzf redis-4.0.8.tar.gz
#            cd redis-4.0.8
#            make
#            make install

#             初始化配置

#            • 配置服务运行参数
#            – 端口
#            – 主配置文件
#            – 数据库目录
#            – pid文件
#            – 启动程序
#            #./utils/install_server.sh
#                 
#             Selected config:
#             Port           : 6379
#             Config file    : /etc/redis/6379.conf
#             Log file       : /var/log/redis_6379.log
#             Data dir       : /var/lib/redis/6379
#             Executable     : /usr/local/bin/redis-server
#             Cli Executable : /usr/local/bin/redis-cli
#                 


#            //初始化启动/停止服务

#            • 启动服务
#            # /etc/init.d/redis_<portnumber> start

#            • 停止服务
#            # /etc/init.d/redis_<portnumber> stop连接Rediss数据库服务

#            • 访问redis服务
#            # ps -C redis
#            # netstat -utnlp | grep redis
#            # redis-cli

#            //连接本机的redis数据库服务常用操作指令

#            – set keyname keyvalue //存储
#            – get keyname //获取
#            – select 数据库编号0-15 //切换库
#            – keys * //打印所有变量
#            – keys a? //打印指定变量
#            – EXISTS keyname //测试是否存在
#            – ttl keyname //查看生存时间
#            – type keyname //查看类型常用操作指令(续1)
#            – move keyname dbname //移动变量
#            – expire keyname 10 //设置有效时间
#            – del keyname //删除变量
#            – flushall //删除所有变量
#            – save //保存所有变量
#            – shutdown //关闭redis服务

#              配置文件解析数据单位
#            • 数据单位
#             – port 6379 //端口
#             – bind 127.0.0.1 //IP地址
#             – tcp-backlog 511 //tcp连接总数
#             – timeout 0 //连接超时时间
#             – tcp-keepalive 300 //长连接时间
#             – daemonize yes //守护进程方式运行
#             – databases 16 //数据库个数
#             – logfile /var/log/redis_6379.log //日志文件
#             – maxclients 10000 //并发连接数量
#             – dir /var/lib/redis/6379 //数据库目录内存管理
#             • 内存清除策略
#             – volatile-lru
#             //最近最少使用 (针对设置了TTL的key)
#             – allkeys-lru //删除最少使用的key
#             – volatile-random //在设置了TTL的key里随机移除
#             – allkeys-random //随机移除key
#             – volatile-ttl (minor TTL) //移除最近过期的key
#             – noeviction //不删除,写满时报错内存管理(续1)
#             • 选项默认设置
#             – maxmemory <bytes> //最大内存
#             – maxmemory-policy noeviction //定义使用策略
#             – maxmemory-samples 5
#             个数 (针对lru 和 ttl 策略) //选取模板数据的设置连接密码
#             • 设置密码
#             [root@localhost ~]# grep -n requirepass /etc/redis/6379.conf
#             501:requirepass 123456
#             [root@localhost ~]# redis-cli
#             127.0.0.1:6379> ping
#             (error) NOAUTH Authentication required.
#             127.0.0.1:6379> auth 123456
#             //输入密码
#             OK
#             127.0.0.1:6379> ping
#             PONG
#             127.0.0.1:6379>
#   -----------------------------------------------------------------------
#   ----------------------MYSQL-day10   分库分表概述  配置mycat-----------------

#         分库分表

#         • 什么是分库分表
#         – 将存放在一个数据库(主机)中的数据,按照特定方式进行拆分,分散存放到多个数据库(主机)中,以达到分散单台设备负载的效果

#           垂直分割
#         
#         • 纵向切分
#         
#         – 将单个表,拆分成多个表,分散到不同的数据库
#         – 将单个数据库的多个表进行分类,按业务类别分散到
#         不同的数据库上水平分割
#         
#         • 横向切分
#         
#         – 按照表中某个字段的某种规则,把表中的许多记录按
#         行切分,分散到多个数据库中




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



# -------------------------------------------------------------------------

#   ----------------------MYSQL-day09   MySQL视图 MySQL存储过程-----------------
#      
#      把ql系统用户信息存储到db9库下的user 表里，并在所有列前添加行号字段id (要求自动增长)
#       
#          一、mysql视图
#          1.1  什么是mysql视图
#        – 虚拟表
#      
#        – 内容与真实的表相似,有字段有记录
#        – 视图并不在数据库中以存储的数据形式存在
#        – 行和列的数据来自定义视图时查询所引用的基表,并
#        且在具体引用视图时动态生成
#        – 更新视图的数据,就是更新基表的数据
#        – 更新基表数据,视图的数据也会跟着改变
#
#      1.2 视图优点
#              • 简单
#              – 用户不需关心视图中的数据如何查询获得
#              – 视图中的数据已经是过滤好的符合条件的结果集
#              • 安全
#              – 用户只能看到视图中的数据
#              • 数据独立
#              – 一旦视图结构确定,可以屏蔽表结构对用户的影响
#
#             视图使用限制
#
#             • 不能在视图上创建索引
#             • 在视图的FROM子句中不能使用子查询
#             • 以下情形中的视图是不可更新的
#             – 包含以下关键字的SQL语句:聚合函数(SUM、MIN、
#               MAX、COUNT等)、DISTINCT、GROUP BY、
#               HAVING、UNION或UNION ALL
#             – 常量视图、JOIN、FROM一个不能更新的视图
#             – WHERE子句的子查询引用了FROM子句中的表
#             – 使用了临时表
#
#
#
#      1.3  视图的基本使用
#      创建视图
#
#       my "create view db9.v1 as select name,uid,shell from db9.user;"
#
#       my "select * from  db9.v1;"
# 
#       my "desc db9.v1;"
#   
#       my "grant select on db9.v1 to yaya@'%'   identified by 'Azsd1234.';"
#
#       my "create view db9.v2(vname,vuid) as select  name,uid from db9.user;"
# 
#       my "select * from db9.v2;desc db9.v2;"   
#   
#
#      查看视图
#
#        
#        my "use db9;show tables;"
#
#
#        my "use db9;show table  status\G;"
#
#        my "use db9;show table status where comment='view'\G;"
#
#
#        my "use mysql ;show table status where comment='view'\G;"
#
#
#        my "show create view db9.v2;"
#
#
#
#      使用视图(update insert )
# 
#v1=db9.v1
#user=db9.user
#v2=db9.v2
#
#     my "update db9.v1 set name='admin' where name='root';"
#
#     my "select name from db9.user;"
# 
#     my "select name from db9.v1;"
#
#     my "delete from $user where name='lucy';"
#
#     my "insert into $user(name,uid) values('lucy',888);"
#
#     my "select name,uid from $user where name='lucy';"
#  
#     my "select name,uid from $v1 where name='lucy';"
#
#      
#
#      删除视图
# 
#      my "drop view db9.v2;"
#      my "drop view db9.user;"
#      my "drop view db9.v1;"
#      my "use db9; show tables;"
# 
#      1.4  AS定义视图中字段名称
#      1.5 OR REPLACEX选项的使用
#
#      视图进阶
#
#
#
#      创建视图的完全格式
#t1=db9.t1
#t2=db9.t2
#a=db9.a
#b=db9.b
#
#        my "create table db9.t1 select name,uid from $user  limit 3 ;"
#
#        my "create table db9.t2 select name,uid from $user  limit 6 ;"
#
#        my "select * from  $t1,$t2  where $t1.name=$t2.name;"
#          
#        my "create view $v1 as select  * from $t1,$t2 where $t1.name=$t2.name;"
# 
#        my "select a.name as  aname , b.name as bname   from $t1 a , $t2 b where a.name=b.name;"
#v3=db9.v3
#v4=db9.v4
#
#        my "create view $v3 as select a.name as  aname , b.name as bname   from $t1 a , $t2 b where a.name=b.name;"
#    
#        my "select * from $v1;"
#
#        my "select t1.name,t2.name from $t1  left join $t2 on $t1.name=$t2.name; "
#
#        my "create view db9.v4(aname,bname) as select t1.name,t2.name from $t1  left join $t2 on $t1.name=$t2.name; "
#
#        my "select * from db9.v4;"
#
#          my "create or replace view  $v4  as select * from $user;"
#
#          my "select * from $v4;"
#
#
#
#
#
#
#
#
#
#
#
#      • 命令格式
#      – CREATE
#      [OR REPLACE]
#      [ALGORITHM = {UNDEFINED | MERGE | TEMPTABLE}]
#      [DEFINER = { user | CURRENT_USER }]
#      [SQL SECURITY { DEFINER | INVOKER }]
#      VIEW view_name [(column_list)]
#      AS select_statement
#      [WITH [CASCADED | LOCAL] CHECK OPTION]设置字段别名
#      • 视图中的字段名不可以重复 所以要定义别名
#      – create view 视图名
#      as
#      select 表别名.源字段名 as 字段别名
#      from 源表名 表别名 left join 源表名 表别名
#      on 条件;
#      mysql> create view v2
#      as
#      select a.name as aname , b.name as bname , a.uid as auid , b.uid
#      as buid from user a left join info b on a.uid=b.uid;重要选项说明
#      • OR REPLACE
#      – Create or replace view 视图名 as select 查询;
#      – 创建时,若视图已存在,会替换已有的视图
#      mysql> create view v2 as select * from t1;
#      Query OK, 0 rows affected (0.01 sec)
#      mysql> create view v2 as select * from t1;
#      ERROR 1050 (42S01): Table ‘v2’ already exists //提示已存在
#      mysql>
#      mysql> create or replace view v2 as select * from t1; //无提示
#      Query OK, 0 rows affected (0.00 sec)
#      mysql>重要选项说明(续1)
#      • ALGORITHM
#      – ALGORITHM = {UNDEFINED | MERAGE |
#      TEMPTABLE}
#      – MERAGE,替换方式;TEMPTABLE,具体化方式
#      – UNDEFINED,未定义重要选项说明(续2)
#      • LOCAL和CASCADED关键字决定检查的范围
#      – LOCAL 仅检查当前视图的限制
#      – CASCADED 同时要满足基表的限制(默认值)
#    user2=db9.user2
#       my "create table $user2 select * from $user where uid>=10 and uid<=1000;"
#       my "select * from $user2;" 
#
#    v5=db9.v5
#
#       my "create view $v5 as select name,uid from $user2;"
# 
#          my "select * from $v5 where uid=11;"
# 
#        my "update $v5 set uid=1111 where name='operator';"
#
#     mysql -e "select * from db9.user2;"
#
# v6=db9.v6
#       my "create view $v6 as select *  from $user2  where uid <=100 with local check option;use db9 ; show tables;"
#  
#       my  "select name,uid from db9.v6;"
#
#       my "update $v6 set uid=101 where name='ftp';"
#       my "update $v6 set uid=77 where name='ftp';"
#
#       my  "select name,uid from db9.v6;"
#
#
#
#v7=db9.v7
#v8=db9.v8
#
#        my "create view $v7 as select name,uid,shell from $user2 where uid>=10 and uid<=50;"
# 
#
#        my "create view $v8 as select name,uid,shell from $v7  where uid>=20 with cascaded check option;select * from $v8; "
#  
#         my "select * from $v7;"
#         my "select * from $v8;"
#   
#         my "update $v8 set uid=16 where name='ntp';"
#         
#         my "update $v8 set uid=51 where name='ntp';"
#
# 
#      mysql> create view v1 as
#      select * from a where uid < 10 with check option;
#      Query OK, 0 rows affected (0.09 sec)
#      mysql> create view v2 as
#      select * from v1 where uid >=5 with local check option;
#      Query OK, 0 rows affected (0.09 sec)
#
#
#      
#      二、mysql存储过程
#
#          存储过程介绍
#
#          • 存储过程,相当于是MySQL语句组成的脚本
#          – 指的是数据库中保存的一系列SQL命令的集合
#          – 可以在存储过程中使用变量、条件判断、流程控制等
#
#          存储过程优点
#
#          • 提高性能
#          • 可减轻网络负担
#          • 可以防止对表的直接访问
#          • 避免重复编写SQL操作
#
#
#      2.1 基本使用：创建  查看  调用   删除 
#
#        创建存储过程
#
#             • 语法格式
#             – > delimiter //
#             create procedure 名称()
#             begin
#             .. .. 功能代码
#             end
#             //
#             //结束存储过程
#             – Delimiter;
#             •
#             •
#             delimiter关键字用来指定存储过程的分隔符(默认为;)
#             若没有指定分割符,编译器会把存储过程当成SQL语句进行处理,从而执行出错
#              my "delimiter //
#                  create procedure db9.p1()
#                  begin
#                  select * from $user limit 10;
#                  end
#                  //
#                  delimiter ;
#                  call db9.p1();"       
#     
#
#p1=db9.p1 
#              my "delimiter //
#                  create procedure db9.p1()
#                  begin
#                  select * from $user limit 10;
#                  end
#                  //
#                  delimiter ;"
#              my "call $p1();"       
#
#               my "delimiter //
#                   create procedure $p1()
#                   begin
#                   select count(*) from $user  where shell='/bin/bash';
#                   end
#                   //
#                   delimiter ;
#                   my "call $p1();"
#              
#
#c1=db9.c1
#
#               my "delimiter //
#                   create procedure $c1()
#                   begin 
#                   select user();
#                   end
#                   //
#                   delimiter ;"
#                   my "call $c1"
#
#
#             查看存储过程
#
#             • 方法1
#
#             – mysql> show procedure status;
#
#             • 方法2
#
#             – mysql> select db,name,type from mysql.proc
#
#             where name="存储过程名";
#
#             mysql> select db,name,type from mysql.proc where name="say";
#
#             +---------+------+-------------+
#             | db
#             | name | type
#             |
#             +---------+------+-------------+
#             | studydb | say | PROCEDURE |
#             +---------+------+-------------+
#
#               my "desc mysql.proc\G;"
#
#               my "select db,name,type from mysql.proc where name='p1';"
#
#               my "select db,name,type from mysql.proc where type='procedure';"
#
#               my "select * from mysql.proc where name='p1'\G;"
#
#               my "select body from mysql.proc where name='p1';"
#
#
#              调用/删除存储过程
#
#              • 调用存储过程
#              – call
#              存储过程没有参数时,()可以省略
#              存储过程有参数时,调用时必须传给参数
#              存储过程名();
#              • 删除存储过程
#              – drop procedure 存储过程名;
#              mysql> call say();
#              +------+----------+------+------+---------+---------+-----------+
#              | name | password | uid | gid | comment | homedir | shell
#              |
#              +------+----------+------+------+---------+---------+-----------+
#              | root | x
#              | 0 | 0 | root
#              | /root
#              | /bin/bash |
#              +------+----------+------+------+---------+---------+-----------+
#              1 row in set (0.00 sec)
#              mysql> drop procedure say;
#              Query OK, 0 rows affected (0.00 sec) 
#    
#               my "drop procedure $p1;"
#   
#               my "call $p1();"
#
#      2.2 存储过程参数类型： in   out   inout
#
#         
# 
#
#             参数类型
#             • 调用参数时,名称前也不需要加@
#             – create procedure 名称(  类型 参数名 数据类型 , 类型 参数名 数据类型 )
#
#
#             关键字
#
#             in    输入参数 作用是给存储过程传值,必须在调用存储过程时赋值,在存储过程中该参数的值不允许修改;默认类型是in
#p5=db9.p5
#
#             my "delimiter //
#                 create procedure $p5( in sname char(25)) 
#                 begin
#                 declare x int(1);
#                 set x = 0;
#                 select count(name) into x  from $user  where shell=sname;
#                 select x;
#                 end
#                 //
#                 delimiter ;"
#
#              my "call $p5();"
#              my "call $p5('/bin/bash');"
#              my "call $p5('/sbin/nologin');"
#              my "call $p5('/sbi/nologin');"
#
#             out   输出参数 该值可在存储过程内部被改变,并可返回。
#
#p6=db9.p6
#              my "drop procedure $p6;"  
#              my "delimiter //
#                  create procedure $p6( out usernum int(2)) 
#                  begin
#                  select count(name) into usernum  from $user  ;
#                  select usernum;
#                  end
#                  //
#                  delimiter ;"
#  
#              my "call $p6();"
#              my "call $p6(7);"
#              my "set @x=7;call $p6(@x);select @x;"
#              my "call $p6(@y); select @y;"
#
#                   
#
#                 
#
#
#             inout 输入/输出参数
#
#p7=db9.p7
#              my "drop procedure $p7;"
#              my "delimiter //
#                  create procedure $p7( inout num int(2)) 
#                  begin
#                  select num;
#                  select count(name) into num  from db9.user where uid<=1000;
#                  select num;
#                  end
#                  //
#                  delimiter ;"
#  
#              my "call $p7();"
#              my "call $p7(7);"
#              my "set @x=5;call $p7(@x);select @x;"
#              my "call $p7(@y);select @y;"
#
#
#             调用时指定,并且可被改变和返回参数类型(续1)
#
#             mysql> delimiter //
#             mysql> create procedure say(in username char(10))
#             //定义in类型的参数变量username
#             -> begin
#             -> select username;
#             -> select * from user where name=username;
#             -> end
#             -> //
#             mysql> delimiter ;参数类型(续2)
#             mysql> call say("root");
#             //调用存储过程时给值
#             +----------+
#             | username |
#             +----------+
#             | root
#             |
#             +----------+
#             1 row in set (0.00 sec)
#             +----+------+------+----------+------+------+---------+---------+---------+
#             | id | name | sex | password | pay | gid | comment | homedir | shell |
#             +----+------+------+----------+------+------+---------+---------+---------+
#             | 01 | root | boy | x
#             | 0 | 0 | root
#             | /root
#             | /bin/bash |
#             +----+------+------+-----
#  
#  
#
#      
#      2.3mysql 变量类型： 会话变量 全局变量   用户变量   局部变量
#
#              变量类型
#
#                  • 调用局部变量时,变量名前不需要加@
#        名称
#
#        会话变量
#        会话变量和全局变量叫系统变量 使用set命令定义;
#        
#    
#          my "show session variables like '%time%';" 
#
# #         my "set session sort_buffer_size=888888;show session variables like 'sort_buffer_size';"
#  
#  #        my  "show  variables like 'sort_buffer_size';"
#
#        全局变量
#  
#          my "show global variables;"
#
#        全局变量的修改会影响到整个服务器,但是对会话
#        变量的修改,只会影响到当前的会话。
#
#           my " select @@hostname;"
#
#
#
#        用户变量
#             在客户端连接到数据库服务的整个过程中都是有效
#             的。当前连接断开后所有用户变量失效。
#           定义 set
#           @变量名=值;
#           输出 select @变量名;a
#
#   #               my "select max(uid) into @y from $user; select @y;"
#
#    #              my "set @x=55; select @x;"
#                    
#
#        局部变量 
#
#           存储过程中的begin/end。其有效范围仅限于该语
#           句块中,语句块执行完毕后,变量失效。
#           declare专门用来定义局部变量。
#             p3=db9.p3
#             my "delimiter //
#                 create procedure $p3()
#                 begin
#                 declare x int(2) default 1;
#                 declare y char(10); 
#                 set y='hha';
#                 select x;
#                 select y;
#                 end
#                 //
#                 delimiter ;"
#                 
#                 my "call $p3();"
#
#
#
#      
#      2.4 mysql运算符号 :   +   -    *   /    DIV   %  
#           • 运算符号及用法示例
#           符号
#           描述
#           示例
#           + 加法运算 SET @var1=2+2;
#           - 减法运算 SET @var2=3-2;
#           * 乘法运算 SET @var3=3*2; 6
#           / 除法运算 SET @var4=10/3; 3.333333333
#           DIV 整除运算 SET @var5=10
#           取模 SET @var6=10%3 ;
#           %
#           4
#           1
#           DIV 3; 3
#           1
#    set       @z=1+2;select @z;
#    set       @x=1; set @y=2;set @z=@x*@y; select @z;
#    set       @x=1; set @y=2;set @z=@x-@y; select @z;
#    set       @x=1; set @y=2;set @z=@x/@y; select @z;
#
#             my "set @x=2;set @j=5 ;set @k=@x * @j;select @k;" 
#
#             my "set @z=1+2;select @z;"
#
#             my "set @x=1 ; set @y=2;set  @z=@x/@y;select @z;"
#             my "set @x=2 ; set @y=5;set  @z=@x div @y;select @z;"
#             my "set @x=9 ; set @y=4;set  @z=@x % @y;select @z;"
#p4=db9.p4     
#             my "drop procedure $p4;" 
#             my "insert into $user(name,shell) values('pop','/bin/bash'),('bob','/sbin/nologin');"
#             my "delimiter //
#                 create procedure $p4()
#                 begin
#                 declare x int(2); 
#                 declare y int(2); 
#                 declare z int(2); 
#                 select count(name) into x  from $user where shell='/bin/bash';
#                 select count(name) into y  from $user where shell='/sbin/nologin';
#                 select x;  
#                 select y;
#                 set z=x+y;
#                 select z;
#                 end
#                 //
#                 delimiter ;"
#
#              my "call $p4"
#
#             my "drop procedure $p4;" 
#             my "insert into $user(name,shell) values('pop','/bin/bash'),('bob','/sbin/nologin');"
#             my "delimiter //
#                 create procedure $p4()
#                 begin
#                 declare x int(2); 
#                 declare y int(2); 
#                 declare z int(2); 
#                 select count(name) into x  from $user where shell='/bin/bash';
#                 select count(name) into y  from $user where shell='/sbin/nologin';
#                 select x;  
#                 select y;
#                 set z=x+y;
#                 select z;
#                 end
#                 //
#                 delimiter ;"
#
#      
#      2.5 条件判断符号：
#p9=db9.p9
#                 my "delimiter //
#                     create procedure $p9( in x int(2) )
#                     begin 
#                     if x is not null then
#                     select * from $user where id=x;
#                     else 
#                     select * from $user where id=1;
#                     end if;
#                     end
#                     //
#                     "
#                 my "call $p9();"
#                 my "call $p9(2);"
#                 my "call $p9(@x);"
#                 my "set @x=3;call $p9(@x);"
#
#
#      >  >=  <  <=   =  !=   or   and   !   like   regexp 
#      is  null    is  not  null    
#      in  
#      not  in 
#      between....and....
#      
#      2.6 流程控制：
#      if 顺序结构
#      if  条件判断  then
#          代码
#          .....
#      end  if ;
#      
#      if  条件判断  then
#          代码
#          .....
#      else
#         代码
#          .....
#      end  if;
#      
#      循环结构
#
#p10=db9.p10
#p11=db9.p11
#p12=db9.p12
#
#             my "delimiter //
#                 create procedure $p10()
#                 begin 
#                 while 1=2 do
#                 select * from db9.user where id=1;
#                 end while;
#                 end
#                 //
#                 delimiter ;
#                 "
#             
#             my "call $p10();"
#            
#
#             my "delimiter //
#                  create procedure $p11()
#                  begin 
#                  while 1=1 do
#                  select * from db9.user where id=1;
#                  end while;
#                  end
#                  //
#                  delimiter ;
#                  "
#
#
#             my "call $p11();"
#
#
#             my "delimiter //
#                  create procedure $p12()
#                  begin
#                  declare x int(2); 
#                  set x = 1;
#                  while x <= 10 do
#                  select x;
#                  set x = x + 1;
#                  end while;
#                  end
#                  //
#                  delimiter ;
#                  "
#             
#             
#             my "call $p12();"
#
#p13=db9.p13
#           循环结构(续1)
#           • loop死循环
#           – 无条件、反复执行某一段代码
#           loop
#           循环体
#           .. ..
#           end loop;
#
#              my "delimiter //
#                create procedure $p13()
#                loop
#                select * from $user where name='bin';
#                end loop;
#                end
#                //
#                delimiter ;"
#
#           循环结构(续2)
#           • repeat条件式循环
#           – 当条件成立时结束循环
#           repeat
#           循环体
#           .. ..
#           until 条件判断
#           end repeat;
#
#p14=db9.p14
#              my "drop procedure $p14;"
#              my "delimiter //
#                  create procedure $p14()
#                  begin 
#                  declare x int(2);
#                  set x = 10;
#                  repeat
#                  select x;
#                  set x = x - 1;
#                  until x < 1    
#                  end repeat;
#                  end
#                  //
#                  delimiter ;"
#
#               my "call $p14();"
#user=a.user
#p15=a.p15
#p16=a.p16
#              my "drop procedure $p16"
#              my "delimiter //
#                  create procedure $p16( in a int(2) , in b int(2)  )
#                  begin 
#                  declare z  int(2);
#                  set z= b-a;
#                  set a= a-1;       
#                  select * from a.user  where uid%2=0  and id in (select id from ( select * from $user limit a,z) as t );
#                  end
#                  //
#                  delimiter ;"
#  
#             my "call $p16(3,15);"
#           
#              my "drop procedure $p15"
#              my "delimiter //
#                  create procedure $p15( in a int(2) , in b int(2)  )
#                  begin 
#                  declare z  int(2);
#                  set z= b-a;
#                  set a= a-1;       
#                  select * from  $user limit a,z;
#                  end
#                  //
#                  delimiter ;"
#  
#             my "call $p15(3,15);"
#
#p17=a.p17
#              my "drop procedure $p17"
#              my "delimiter //
#                  create procedure $p17( in a int(2) , in b int(2)  )
#                  begin 
#                  declare z  int(2);
#                  set a= a-1;
#                  set b= b-1;
#                  while  a < b do
#                  select uid into z  from $user limit a,1;
#                  if z%2=0 then 
#                  select * from  $user limit a,1;
#                  end if;
#                  set a = a+1 ;
#                  end while;
#                  end
#                  //
#                  delimiter ;"
#  
#             my "call $p17(3,15);"
#                my "drop procedure $p16;"  
#                my "delimiter //
#                   create procedure $p16( in a int(2) )
#                   if a is null then 
#                   select * from $user limit 1;
#                   else
#                   set a = a-1;
#                   select * from $user limit a,1;
#                   end if;
#                   end
#                   //
#                   delimiter ;
#                   "
#
#               my  "call $p16(2);"
#               my  "call $p16(@x);"
#
#               my  "call $p16(14);"
#
#      循环控制参数
#
#   ----------------------MYSQL-day08  部署MYSQL高可用集群-----------------
#
#       集群定义： 使用多台服务提供相同的服务
#
#       高可用集群定义：主备模式，被客户端访问的称作主，当主宕机时，备用     
#       服务器自动接收客户端访问。
#       
#       配置mysql数据库服务高可用集群（MHA  + 主从同步）
#
#        MHA软件介绍
#
#        配置MHA集群
#
#        安装软件包：
#
#         将规划好的vip 地址192.168.4.100 分配 给 当前 主服务器 192.168.4.51 
#
#        ifconfig eth0:1 192.168.4.100
#
#         在所有数据节点上授权监控用户
#
#        my "grant all on *.* to root@'%' identified by 'Azsd1234.';"
#
#        my "select user,host from mysql.user;"
#
#        在所有主机上安装perl软件包 （51~56）
#
#         cd  mha-soft-student
#         yum -y  install  perl-*.rpm
#         
#        在所有主机上安装mha_node软件包 （51~56）
#
#         yum  -y  install   perl-DBD-mysql
#         rpm  -ivh  mha4mysql-node-0.56-0.el6.noarch.rpm
#         
#        只在管理 "主机56" 上安装mha_manager软件包
#
#         yum -y  install    perl-ExtUtils-*     perl-CPAN*
#         tar  -zxvf  mha4mysql-manager-0.56.tar.gz
#         cd  mha4mysql-manager-0.56
#         perl  Makefile.PL  
#         make
#         make install
#         
# 
#        拷贝命令（56）
#
#          cp  mha4mysql-manager-0.56/bin/*    /usr/local/bin/
#
#           相关命令
#           • manager节点提供的命令工具
#           命令
#           作用
#           masterha_check_ssh 检查MHA的SSH配置状况
#           masterha_check_repl 检查MySQL复制状况
#           masterha_manager 启动MHA
#           masterha_check_status 检测MHA运行状态
#           masterha_master_monitor 检测master是否宕机
#
#
#         在主机51 52  53  检查是否有同步数据的用户 repluser   
#
#          show  grants  for  repluser@"%" ;
#         
#         在主机51~55 做如下设置   不自动删除本机的中继日志文件
#
#
#           my  "show variables like 'relay_log_purge';"
#           my  "set global relay_log_purge=off;"
#           my  "show variables like 'relay_log_purge';"
#         
#         
#          创建工作目录 和主配置文件 （56）
#
#           mkdir    /etc/mha_manager/
#         
#           cp  mha4mysql-manager-0.56/samples/conf/app1.cnf   /etc/mha_manager/
#         
#          编辑主配置文件 app1.cnf(56)
# 
#           vim  /etc/mha_manager/app1.cnf
#
#          创建故障切换脚本（56）
#
#          ls  /usr/local/bin/master_ip_failover
#         
#          cp mha4mysql-manager-0.56/samples/scripts/master_ip_failover 
#         
#          /usr/local/bin/
#         
#         
#         验证配置
#
#         验证ssh 免密码登录 数据节点主机
#
#          masterha_check_ssh --conf=/etc/mha_manager/app1.cnf
#         
#         Sun May  6 16:38:19 2018 - [info] All SSH connection tests passed 
#         
#         successfully.
#         
#         验证 数据节点的主从同步配置（要不调用故障切换脚本）
#
#         masterha_check_repl --conf=/etc/mha_manager/app1.cnf
#         
#         MySQL Replication Health is OK.
#         
#         
#         四、测试高可用集群配置
#
#         4.1 在主库上手动部署vip 地址   192.168.4.100
#
#          ifconfig  eth0:1 192.168.4.100/24
#         
#          ifconfig  eth0:1
#         eth0:1: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 
#         
#         1500
#                 inet 192.168.4.100  netmask 255.255.255.0  broadcast 
#         
#         192.168.4.255
#                 ether 74:52:09:07:51:01  txqueuelen 1000  (Ethernet)
#         
#         
#         4.2 修改故障切换脚本 指定vip地址的部署信息
#          vim /usr/local/bin/master_ip_failover 
#         my $vip = '192.168.4.100/24';  # Virtual IP 
#         my $key = "1";
#         my $ssh_start_vip = "/sbin/ifconfig eth0:$key $vip";
#         my $ssh_stop_vip = "/sbin/ifconfig eth0:$key down";
#         ：wq
#         
#         4.3 启动管理服务，并查看服务状态
#          masterha_manager --conf=/etc/mha/app1.cnf 
#         --remove_dead_master_conf   --ignore_last_failover
#         
#            – --remove_dead_master_conf //删除宕机主库配置
#            – --ignore_last_failover   //忽略xxx.health文件         
#         
#          masterha_check_status --conf=/etc/mha_manager/app1.cnf
#         app1 (pid:16944) is running(0:PING_OK), master:192.168.4.51
#          
#         
#         ++++++++++++++++++++++++++++++++++++++++++++++++
#         4.4 测试故障转移
#         在主库51 上执行  ]# shutdown   -h  now
#         
#         
#         4.5 在管理主机上查看服务状态(如果服务停止了，手动启动一下服务，再查看状态)
#          masterha_check_status --conf=/etc/mha_manager/app1.cnf
#         app1 (pid:17507) is running(0:PING_OK), master:192.168.4.52
#         
#         
#         4.6 在52 本机查看是否获取vip地址
#         # ip addr  show  | grep  192.168.4
#             inet 192.168.4.52/24 brd 192.168.4.255 scope global eth0
#             inet 192.168.4.100/24 brd 192.168.4.255 scope global secondary eth0:1
#         
#         
#         4.6 客户端连接vip地址 ，访问数据服务
#        mysql   -h192.168.4.100   -uwebadmin   -p123456
#         mysql> 
#
#
#       
#       测试高可用集群配置
#        在主库上手动部署vip 地址   192.168.4.100
#        修该故障切换脚本 指定vip地址的部署信息
#        启动管理服务，并查看服务状态
#
#
#
#  
#
#
#---------------------------------------------------------------------------
#
#   ----------------------MYSQL-day07   MySQL读写分离-------------------------
#
#   一、数据读写分离
# 
#       什么是数据读写分离？
#
#             把客户端访问数据时的查询请求和写请求分别给不同的数据库服务器处理。
#
#       为要对数据做读写分离？
#
#         减轻单台数据库服务器的并发访问压力
#
#         提高数据库服务器硬件利用率
#
#       读写分离的原理
#
#       • 多台MySQL服务器
#
#       – 分别提供读、写服务,均衡流量
#       – 通过主从复制保持数据一致性
#
#       • 由MySQL代理面向客户端
#
#       – 收到SQL写请求时,交给服务器A处理
#       – 收到SQL读请求时,交给服务器B处理
#       – 具体区分策略由服务设置
#
#       实现数据读写分离的方式？
#
#        人肉分离：  做不同的数据操作时，访问指定的数据库服务器
#
#        使用mysql中间件提供的服务实现：mycat   mysql-proxy   maxscale
#
#        使用中间件提供的服务做数据读写分离的缺点？
#
#         单点故障
#         当访问量大时，会成为网络瓶颈
#      二、配置数据读写分离
#
#         2.1  拓扑结构			        webuser    123456
#    	client254   mysql  -h192.168.4.56  -u用户名    -p密码
#
#    	      |
#                 代理服务器56
#                      |
#    ______________________________________
#            write		   read
#                |                   |
#            master                slave
#              51	            52
#
#
#     2.2 配置数据读写分离
#     2.2.1  配置一主一从  主从同步结构，并在客户端测试配置
#     master51> grant  all  on  webdb.*  to webuser@"%"  identified by " 123456";
#     
#     2.2.2  配置数据读写分离服务器
#     2.2.2.1环境准备
#     setenforce  0
#     systemctl  stop  firewalld
#     yum repolist
#     ping  -c  2  192.168.4.51
#     ping  -c  2  192.168.4.52
#     下载软件包 maxscale-2.1.2-1.rhel.7.x86_64.rpm
#     
#     2.2.2.2 配置数据读写分离服务器56
#     1 装包
#     
#     2 修改配置文件
#     vim  /etc/maxscale.cnf
#       9 [maxscale]  //服务运行后开启线程的数量
#      10 threads=auto
#     
#     #定义数据库服务器
#      18 [名称]    
#      19 type=server
#      20 address=数据库服务器的ip地址
#      21 port=3306
#      22 protocol=MySQLBackend
#     
#     #定义监控的数据库服务器
#      36 [MySQL Monitor]
#      37 type=monitor
#      38 module=mysqlmon
#      39 servers=数据库服务器列表
#      40 user=监视数据库服务器时连接的用户名
#      41 passwd=密码
#      42 monitor_interval=10000
#     
#     #不定义只读服务
#      53 #[Read-Only Service]
#      54 #type=service
#      55 #router=readconnroute
#      56 #servers=server1
#      57 #user=myuser
#      58 #passwd=mypwd
#      59 #router_options=slave
#     
#     #定义读写分离服务
#      64 [Read-Write Service]
#      65 type=service
#      66 router=readwritesplit
#      67 servers=数据库服务器列表
#      68 user=用户名 #验证连接代理服务访问数据库服务器的用户是否存在
#      69 passwd=密码
#      70 max_slave_connections=100%
#     
#     #定义管理服务
#      76 [MaxAdmin Service]
#      77 type=service
#      78 router=cli
#     
#     #不指定只读服务使用的端口号
#      86 #[Read-Only Listener]
#      87 #type=listener
#      88 #service=Read-Only Service
#      89 #protocol=MySQLClient
#      90 #port=4008
#     
#     #定义读写分离服务使用的端口号
#      92 [Read-Write Listener]
#      93 type=listener
#      94 service=Read-Write Service
#      95 protocol=MySQLClient
#      96 port=4006  #设置使用的端口
#     
#     #定义管理服务使用的端口
#      98 [MaxAdmin Listener]
#      99 type=listener
#     100 service=MaxAdmin Service
#     101 protocol=maxscaled
#     102 socket=default
#            port=4018    #不设置使用的默认端口
#     
#     
#     3 根据配置文件的设置，在2台数据库服务器上添加授权用户
#     4 启动服务
#     5 查看服务进程和端口
#     
#     2.2.3 测试配置
#     a 在本机访问管理管端口查看监控状态
#     ]#maxadmin  -P端口  -u用户   -p密码
#     ]#maxadmin -P4016  -uadmin   -pmariadb 
#      
#     b 客户端访问数据读写分离服务
#     ]#which  mysql
#     ]#mysql  -h读写分离服务ip   -P4006   -u用户名  -p密码
#     
#     ]# mysql -h192.168.4.56 -P4006 -uwebuser -p123456
#     mysql>  select  @@hostname
#     mysql>  执行插入或查询 （ 在51 和 52 本机查看记录）
#
#
#
#     配置数据读写分离
#
#       配置一主一从  主从同步结构，并在客户端测试配置
#
#       grant  all  on  webdb.*  to webuser@"%"  identified by " 123456";
#     
#       配置数据读写分离服务器
#
#        环境准备
#        setenforce  0
#        systemctl  stop  firewalld
#        yum repolist
#        ping  -c  2  192.168.4.51
#        ping  -c  2  192.168.4.52
#
#     下载软件包 maxscale-2.1.2-1.rhel.7.x86_64.rpm
#     
#     配置数据读写分离服务器 50
#
#     1 装包
#
#        yum -y reinstall maxscale-2.1.2-1.rhel.7.x86_64.rpm
#
#     2 修改配置文件
#    
#        cof=/etc/maxscale.cnf
#
#
#          [maxscale]  //服务运行后开启线程的数量
#          threads=auto
#
#        sed -i '/threads/s/1/auto/' $cof
#
#
#     #定义数据库服务器
#
#          [名称]    
#          type=server
#          address=数据库服务器的ip地址
#          port=3306
#          protocol=MySQLBackend
#
#          sed -rie ":begin; /\[server/,/end/ { /end/! { $! { N; b begin }; }; s/\[server1(.*end)/\[server1\1\n\n\[server2\1/; };" $cof 
# 
#              [server1]
#              type=server
#              address=127.0.0.1
#              port=3306
#              protocol=MySQLBackend
#              
#              [server2]
#              type=server
#              address=127.0.0.1
#              port=3306
#              protocol=MySQLBackend
#
#
#          sed -rie ":begin; /\[server1/,/0.1/ { /0.1/! { $! { N; b begin }; }; s/(\[server1.*address=).*/\1192.168.4.51/; };"  $cof
#
#
#              [server1]
#              type=server
#              address=192.168.4.51
#              port=3306
#              protocol=MySQLBackend
#              
#              [server2]
#              type=server
#              address=127.0.0.1
#              port=3306
#              protocol=MySQLBackend
#
#          sed -rie ":begin; /\[server2/,/0.1/ { /0.1/! { $! { N; b begin }; }; s/(\[server2.*address=).*/\1192.168.4.52/; };"  $cof
#
#              [server1]
#              type=server
#              address=192.168.4.51
#              port=3306
#              protocol=MySQLBackend
#              
#              [server2]
#              type=server
#              address=192.168.4.52
#              port=3306
#              protocol=MySQLBackend
#
#              sed -rie '/^servers/s/$/, server2/' $cof
#
#              sed -ri '/^passwd/s/=.*/=Azsd1234./'  $cof
#
#
#     
#          定义监控的数据库服务器
#
#             36 [MySQL Monitor]
#             37 type=monitor
#             38 module=mysqlmon
#             39 servers=数据库服务器列表
#             40 user=监视数据库服务器时连接的用户名
#             41 passwd=密码
#             42 monitor_interval=10000
#     
#             sed -rie  ":begin; /^\[MySQL/,/10000/ { /10000/ ! { $! { N; b begin};}; s/(.*)user=(.*)\n(.*)\n(.*)/\1user=scalemon\n\3\n\4/ }; "  $cof
#       
#
#          #不定义只读服务
#
#             53 #[Read-Only Service]
#             54 #type=service
#             55 #router=readconnroute
#             56 #servers=server1
#             57 #user=myuser
#             58 #passwd=mypwd
#             59 #router_options=slave
#
#             sed -rie ":begin; /\[Read-Only/,/slave/ { /slave/! { $! { N; b begin }; }; s/\n/\n#/g;s/^/#/ };" $cof
#     
#         #定义读写分离服务
#
#             64 [Read-Write Service]
#             65 type=service
#             66 router=readwritesplit
#             67 servers=数据库服务器列表
#             68 user=用户名 #验证连接代理服务访问数据库服务器的用户是否存在
#             69 passwd=密码
#             70 max_slave_connections=100%
#    
#             sed -rie  ":begin; /\[Read-Write/,/100%/ { /100%/ ! { $! { N; b begin};}; s/(.*)user=(.*)\n(.*)\n(.*)/\1user=scaleuser\n\3\n\4/ }; "  $cof     
#
#          #定义管理服务
#
#             76 [MaxAdmin Service]
#             77 type=service
#             78 router=cli
#     
#          #不指定只读服务使用的端口号
#
#             86 #[Read-Only Listener]
#             87 #type=listener
#             88 #service=Read-Only Service
#             89 #protocol=MySQLClient
#             90 #port=4008
#
#            sed -rie ":begin; /\[Read-Only Lis/,/4008/ { /4008/! { $! { N; b begin }; }; s/\n/\n#/g;s/^/#/ };" $cof
#     
#          #定义读写分离服务使用的端口号
#
#             92 [Read-Write Listener]
#             93 type=listener
#             94 service=Read-Write Service
#             95 protocol=MySQLClient
#             96 port=4006  #设置使用的端口
#
#
#     
#          #定义管理服务使用的端口
#
#             98 [MaxAdmin Listener]
#             99 type=listener
#            100 service=MaxAdmin Service
#            101 protocol=maxscaled
#            102 socket=default
#                port=4018    #不设置使用的默认端口
#     
#            sed -i   '$a port=4016' $cof    
# 
#     3 根据配置文件的设置，在2台数据库服务器上添加授权用户
#   
#        grant replication slave, replication client on *.* to
#        scalemon@'%' identified by 'Azsd1234.';
#
#        //创建监控用户
#
#        grant select on mysql.* to maxscale@‘%’ identified by   'Azsd1234.';
#
#        //创建路由用户
#
#        grant all on *.* to student@'%' identified by 'Azsd1234.';        
#        
#     4 启动服务
#       
#        maxscale -f /etc/maxscale.cnf
#
#        maxadmin  -uadmin -pmariadb -P4016 -e "list servers"
#
#
#     5 查看服务进程和端口
#     
#     2.2.3 测试配置
#
#     a 在本机访问管理管端口查看监控状态
#
#     maxadmin  -P端口  -u用户   -p密码
#     maxadmin -P4016  -uadmin   -pmariadb 
#      
#     b 客户端访问数据读写分离服务
#     which  mysql
#     mysql  -h读写分离服务ip   -P4006   -u用户名  -p密码
#     
#     mysql  -h192.168.4.56 -P4006 -uwebuser -p123456
#
#     mysql>  select  @@hostname
#
#     二、mysql多实例
#
#     2.1 多实例介绍
#
#         多实例概述
#
#         • 什么是多实例
#
#           – 在一台物理主机上运行多个数据库服务
#        
#         
#         • 为什么要使用多实例
#
#           – 节约运维成本
#           – 提高硬件利用率
#
#
#     2.2 配置多实例
#     1 环境准备
#     2 安装提供多多实例服务的mysql数据库服务软件
#     3 编辑配置文件  /etc/my.cnf
#     rm  -rf  /etc/my.cnf
#     vim  /etc/my.cnf
#     [mysqld_multi]   #启用多实例 
#     mysqld = /usr/local/mysql/bin/mysqld_safe   #服务启动调用的进程   
#     mysqladmin = /usr/local/mysql/bin/mysqladmin   #管理命令路径
#     user = root   #调用启动程序的用户名
#     [mysqld1]   #实例编号
#     
#     port=3307  #监听端口
#     datadir=/dataone   #数据库目录
#     
#     socket=/dataone/mysqld.sock    #sock文件
#     log-error=/dataone/mysqld.log #错误日志
#     
#     pid-file=/dataone/mysqld.pid   #pid号文件
#     :wq
#     4 根据配置文件的设置，做相应的配置
#     4.1创建数据库目录
#     4.2创建进程运行的所有者和组 mysql
#     4.3 初始化授权库
#     mysqld  --user=mysql  --basedir=软件安装目录  --datadir=数据库目录   --initialize
#     5 启动多实例服务
#      mysqld_multi   start   实例编号
#     6 访问多实例服务
#     mysql -uroot   -p'密码'  -S    sock文件   #首次登录，使用初始密码
#     +++划重点：使用初始密码登录后，要求修改登录密码
#     mysql> ALTER USER user() identified   by   "新密码";
#     7 停止多实例服务
#     mysqld_multi  --user=root  --password=密码  stop  实例编号
#    #     
# 
#      tar -xf   mysql-5.7.20-linux-glibc2.12-x86_64.tar.gz
#
#      mv  mysql-5.7.20-linux-glibc2.12-x86_64 /usr/local/mysql
#
#      sed -i '$a export PATH=/usr/local/mysql/bin/:$PATH'  /etc/profile
#
#      source /etc/profile
# 
#      [ -f /etc/my.cnf ] && mv /etc/my{.cnf,.bak}
#
#      echo "[mysqld_multi]
#      mysqld = /usr/local/mysql/bin/mysqld_safe
#      mysqladmin = /usr/local/mysql/bin/mysqladmin
#      user = root
#      
#      [mysqld1]
#      port=3307
#      datadir=/data3307
#      socket=/data3307/mysql.sock
#      pid-file=/data3307/mysqld.pid
#      log-error=/data3307/mysqld.err
#      [mysqld2]
#      port = 3308
#      datadir = /data3308
#      socket = /data3308/mysql.sock
#      pid-file = /data3308/mysqld.pid
#      log-error = /data3308/mysqld.err
#      "       > a.txt
#      
#      mkdir /data3307
#      mkdir /data3308
#      
#      mysqld_multi start 1
#      
#      mysqld_multi start 2  
#                                         
#  三、mysql调优
#  3.1 mysql体系结构 （由8个功能模块组成）：
#  管理工具： 安装服务软件后，提供的命令 
#              mysqldump 
#  		mysqlbinlog
#  		mysqladmin
#  连接池： 当接收到客户端的连接请求后，检查是否有资源响应客户端的连接请求。
#   
#  SQL接口： 把sql传递给mysqld线程处理
#  
#  分析器： 检查执行的sql命令是否有语法错误，和是否有访问权限。
#  
#  优化器：优化执行的sql命令，已最节省资源的方式执行sql命令
#  
#  查询缓存： 缓存曾经查找到的记录,缓存空间从物理内存划分出来的。
#  
#  存储引擎： 是表的处理器，不同的存储引擎有不同的功能和数据存储方式。Myisam   innodb
#  
#  文件系统： 存储表中记录的磁盘
# 
#  3.2mysql服务处理查询请求过程：
#  数据服务器接收到查询请求后，先从查询缓存里查找记录，若查询缓存里有查找记录，直接从缓存提取数据给客户端，
#  
#  反之到表去查询记录，把查到的记录先存放到查询缓存里在返回给客户端。
#  
#  3.3mysql调优
#  3.3.1 如何优化mysql数据库服务器（那些原因会导致数据库服务器处理客户端的连接请求慢）
#  A、硬件配置低，导致处理速度慢。 CPU  内存  存储磁盘
#                                                                 接口   转速    15000/s
#  uptime     free  -m      top  --> 0.0 wa
#  
#  b  、网络带宽窄   网络测速软件
#  
#  
#  c 、提供服务软件的版本低，导致性能低下：
#  1 查看服务运行时的参数配置   my.cnf
#  mysql> show  variables;
#
#  
#  mysql> show  variables   like "%innodb%";
#  2 常用参数：
#  并发连接数量
# 
#  Max_used_connections/max_connections=0.85
#    500/x=0.85  * 100%   = 85%
#  
#     my "show variables like  '%conn%';"
#     my "set global max_connections=500;"
#     my "show variables like  '%conn%';"
#   
#     my "show global status;"
#  
#     my "show global  status  like 'Max_used%';"
#
#     show  global  status  like "Max_used_connections";
#     set  global   max_connections  =   数字；
#
#  
#   连接超时时间
#   
# #     my "show variables like '%timeout%';"
#
#    show   variables   like   "%timeout%";
#
#    connect_timeout 10     客户端与服务器建立连接时tcp三次握手超时是时间
#
#    wait_timeout    28800  客户端与服务器建立连接后，等待执行sql命令的超时时间。
#   
#    dev.mysql.com/doc/
#
# 
#          缓存参数控制
#          • 缓冲区、线程数量、开表数量
#          选 项
#          含 义
#          key_buffer-size 用于MyISAM引擎的关键索引缓存大小
#          sort_buffer_size 为每个要排序的线程分配此大小的缓存空间
#          read_buffer_size 为顺序读取表记录保留的缓存大小
#          thread_cache_size 允许保存在缓存中被重用的线程数量
#          table_open_cache 为所有线程缓存的打开的表的数量
#
#           my "show variables like '%buffer%';"
  
  
#  
#  可以重复使用的线程的数量  thread
#  show   variables   like   "%thread%";
#   my "show variables like '%thread%'; "
#  thread_cache_size = 9
#  
#  所有线程同时打开表的数量
#  show   variables   like   "%open%";
#  table_open_cache
#  
#  mysqld  -----> disk ---->x.ibd ----> memory  ----> disk
#  
#  与查询相关参数的设置  (字节)   mysqld
#  select   *  from   t1;   read_buffer_size
#  
#  select   *  from   t1  order  by   字段名;sort_buffer_size
#  
#  
#  select   *  from   t1  group  by   字段名;read_rnd_buffer_size
#  name ----> index
#  select  * from  t1  where  name="jim"; key_buffer-size  
#  
#  
#  与查询缓存相关参数的设置
#  show   variables   like   "%cache%";
#  show   variables   like   "query_cache%";
#  
#  query_cache_wlock_invalidate | OFF  关
#  当对myisam存储引擎的表执行查询时，若检查到有对表做写de sql操作,不从查询缓存里查询数据返回给客户端，而是
#  
#  等写操作完成后，重新查询数据返回给客户端。
#  
#  pc1   select    name  from t1  where name="bob";
#                     cache --->  name=bob
#  
#  pc2 select    name  from t1  where name="bob";
#       mysqld->  name= bob;
#  
#  pc3  update  t1  set  name="jack" wehre  name="bob";
#  
#  查看查询缓存的统计信息：
#  show   global   status   like   "qcache%";
#  Qcache_hits        10     记录在查询缓存里查询到数据的次数     
#  Qcache_inserts   100   记录在查询缓存里查找数据的次数  
#  Qcache_lowmem_prunes    清理查询缓存空间的次数
#  
#  3 修改服务运行时的参数：
#  3.1 命令行设置，临时生效。
#  mysql>  set   [global]  变量名=值；
#  
#  3.2在配置文件里设置永久生效:
#  vim /etc/my.cnf
#  [mysqld]
#  变量名=值
#  :wq
#  
#  4、程序编写sql查询语句太复杂导致，数据库服务器处理速度慢。
#  开启数据库服务器的慢查询日志，记录超过指定时间显示查询结果的sql命令。                                           10s
#  
#  4.1 mysql数据库服务日志类型：
#  错误日志  默认开启 记录服务在启动和运行过程中产生的错误信息log-error=/var/log/mysqld.log
#  binlog日志 又被称作二进制日志：
#  慢查询日志： 记录超过指定时间显示查询结果的sql命令
#  查询日志： 记录所有sql命令。
#  5、网络架构有问题（有数据传输瓶颈） 
#
#    MySQL性能调优
#       三、mysql调优
#       3.1 mysql体系结构 （由8个功能模块组成）：
#       管理工具： 安装服务软件后，提供的命令 
#                                       mysqldump  
#       		mysqlbinlog
#       		mysqladmin
#       连接池： 当接收到客户端的连接请求后，检查是否有资源响应客户端的连接请求。
#        
#       SQL接口： 把sql传递给mysqld线程处理
#       
#       分析器： 检查执行的sql命令是否有语法错误，和是否有访问权限。
#       
#       优化器：优化执行的sql命令，已最节省资源的方式执行sql命令
#       
#       查询缓存： 缓存曾经查找到的记录,缓存空间从物理内存划分出来的。
#       
#       存储引擎： 是表的处理器，不同的存储引擎有不同的功能和数据存储方式。Myisam   innodb
#       
#       文件系统： 存储表中记录的磁盘
#       
#       3.2mysql服务处理查询请求过程：
#       数据服务器接收到查询请求后，先从查询缓存里查找记录，若查询缓存里有查找记录，直接从缓存提取数据给客户端，
#       
#       反之到表去查询记录，把查到的记录先存放到查询缓存里在返回给客户端。
#       
#       3.3mysql调优
#       3.3.1 如何优化mysql数据库服务器（那些原因会导致数据库服务器处理客户端的连接请求慢）
#       A、硬件配置低，导致处理速度慢。 CPU  内存  存储磁盘
#                                                                      接口   转速    15000/s
#       uptime     free  -m      top  --> 0.0 wa
#       
#       b  、网络带宽窄   网络测速软件
#
#    • 提高MySQL系统的性能、响应速度
#    – 替换有问题的硬件(CPU/磁盘/内存等)
#   
#    
#    
#   
#    – 服务程序的运行参数调整
#    – 对SQL查询进行优化
#
#
#      my "show processlist;"
#
#      my "show status;"
#
#     my "show status like '%innodb%';"
#
#      my "show status like 'Innodb_row_lock_waits';"
#
#
#     查看服务运行时的参数配置   my.cnf
#
#      my "show variables;"
#   
#      my "show variables like 'connect_timeout';"
#
#      my "set GLOBAL connect_timeout = 20;
#          show variables like 'connect_timeout';"
#
#      vim /etc/my.cnf
#
#      [msyqld]
#      connect_timeout = 20; 


#      查询缓存： 缓存曾经查找到的记录,缓存空间从物理内存划分出来的。


#          my "show variables like '%cache%';"        

#          my "show variables like 'query_cache%';"

#          | Variable_name                | Value   |
#          +------------------------------+---------+
#          | query_cache_limit            | 1048576 |
#          | query_cache_min_res_unit     | 4096    |
#          | query_cache_size             | 1048576 |
#          | query_cache_type             | OFF     |
#          | query_cache_wlock_invalidate | OFF 


#           query_cache_type  0 1 2

#           0  禁用查询缓存
  
#           1  启用查询缓存 有空间就存

#           2  启用查询缓存 但需要手动设置缓存本次查询结果
   
#           query_cache_limit     | 1048576  大于1m不进入查询缓存 

#           query_cache_min_res_unit     | 4096  最小存储单元

#           query_cache_size             | 1048576 

#           myisam






#           query_cache_wlock_invalidate | OFF  查询缓存写锁无效 off 


#           show global status like 'qcache%'; 
#          
#          +-------------------------+---------+
#          | Variable_name           | Value   |
#          +-------------------------+---------+
#          | Qcache_free_blocks      | 1       |
#          | Qcache_free_memory      | 1031832 |
#          | Qcache_hits             | 0       |   命中率
#          | Qcache_inserts          | 0       |   查询缓存次数
#          | Qcache_lowmem_prunes    | 0       |
#          | Qcache_not_cached       | 257     |
#          | Qcache_queries_in_cache | 0       |
#          | Qcache_total_blocks     | 1       |
#          +-------------------------+---------+

#          MySQL日志类型

#          • 常用日志种类及选项

#          类 型  错误日志   查询日志 慢查询日志

#          错误日志     记录启动/运行/停止过程中的错误消息

#          log-error[=name]

#          查询日志     记录客户端连接和查询操作

#          general-log
#          general-log-file=

#           sed -i '/^\[mysqld]/a  general-log' /etc/my.cnf
#           systemctl restart mysqld


#          慢查询日志   记录耗时较长或不使用索引的查询操作

#          slow-query-log
#          slow-query-log-file=
#          long-query-time=
#          优化SQL查询
#          • 记录慢查询
#          slow-query-log        启用慢查询
#          slow-query-log-file   指定慢查询日志文件
#          long-query-time       超过时间(默认10秒)
#          log-queries-not-using-indexes 记录未使用索引的查询
#
#           sed -i '/^\[mysqld]/a  slow-query-log' /etc/my.cnf

#           systemctl restart mysqld

#             my "select sleep(11);"


#             my "select sleep(15);"



#                调优思路总结
#                手段
#                具体操作
#                升级硬件 CPU 、内存、硬盘
#                加大网络带宽 付费加大带宽
#                调整mysql服务运行参数 并发连接数、连接超时时间、重复使用的
#                线程数........
#                调整与查询相关的参数 查询缓存、索引缓存.......
#                启用慢查询日志 slow-query-log
#                网络架构不合理 调整网络架构
#                


#   ----------------------------------------------------------------------------
#   ----------------------MYSQL-day06   部署MYSQL主从同步-------------------------
#
# 
#
#
#
#
#       一、什么是mysql主从同步
#
#           主：正在被客户端访问的数据库服务器，被称作主库服务器。
#           从：自动同步主库上的数据的数据库服务器，被称作从库服务器。
#
#                实现数据的自动备份  
# 
#
#       二、配置mysql主从同步
#
#           2.1 拓扑图
#
#         192.168.2.100/24   192.168.2.200/24
#               __               __
#              |主|  复制/同步  |从|  
#              |  |-----------> |  |
#              |__|             |__|
#            读取/写入          读取
#                +               +    
#                |               |
#             ------------------------              
#                        |
#                        |          
#                        +
#                      客户端
#
#           数据库服务器 192.168.4.51  做主库
#           数据库服务器 192.168.4.52  做从库
#
#mysqldump   -A > a.sql
#
#
#       配置mysql主从同步
#
#           配置主库
#
#              a 创建用户授权
#                 
#                 my "grant replication slave on *.*  to repluser@'%' identified by 'Azsd1234.';"
#  
#                 my "select user,host from mysql.user;"                           
#                        
#              b 启用binlog日志
#
#                sed -i '/\[mysqld]/a   binlog-format="mixed"'  /etc/my.cnf
#                sed -i '/\[mysqld]/a   log-bin=master100 '     /etc/my.cnf
#                sed -i '/\[mysqld]/a   server_id=100'          /etc/my.cnf 
#       
#                systemctl restart mysqld
#
#                my "show master status;"
#
#              c 查看正在使用binlog日志信息
#    
#                ls /var/lib/mysql/master*
#       
#           配置从库
#               ssh-copy-id  192.168.2.200
#             
#              a 验证主库的用户授权
#
#              b 指定server_id
#    ssh 192.168.2.200         "sed -i '/\[mysqld]/a   server_id=200'  /etc/my.cnf" 
#    ssh 192.168.2.200 "systemctl  restart mysqld"
#
#              c 数据库管理员本机登录，指定主数据库服务器的信息
#
#                 change  master  to
#                 master_host="主库ip地址",
#                 master_user="主库授权用户名",
#                 master_password="授权用户密码",
#                 master_log_file="主库binlog日志文件名",
#                 master_log_pos=binlog日志文件偏移量;
#
#
#                  mysql> change master to
#                      -> master_host="192.168.2.100",
#                      -> master_user="repluser",
#                      -> master_password="Azsd1234.",
#                      -> master_log_file="master100.000001",
#                      -> master_log_pos=441;
#
#
#              d 启动slave进程
#
#                start slave
#
#              e 查看进程状态信息
#       
#        相关命令
#             show  slave  status;  # 显示从库状态信息
#             show master status;  #显示本机的binlog日志文件信息
#             show  processlist;  #查看当前数据库服务器上正在执行的程序
#             start  slave ; #启动slave 进程
#             stop  slave ; #停止slave 进程
#
#        在客户端测试主从同步配置
#          在主库服务器上添加访问数据时，使用连接用户
#                my "grant select,insert on db5.* to yaya@'%' identified by 'Azsd1234.';"
#          客户端使用主库的授权用户，连接主库服务器，建库表插入记录
#
#              mysql> select  user();
#        +------------------+
#        | user()           |
#        +------------------+
#        | yaya@192.168.2.5 |
#        +------------------+
#        
#        mysql> show grants for yaya@'%';
#        +-----------------------------------------------+
#        | Grants for yaya@%                             |
#        +-----------------------------------------------+
#        | GRANT USAGE ON *.* TO 'yaya'@'%'              |
#        | GRANT SELECT, INSERT ON `db5`.* TO 'yaya'@'%' |
#        
#        mysql> use db5;
#        
#        mysql> insert into b values('haha');
#        
#        mysql> insert into b values('xixi');
#
#
#
#2.4.3  在从库本机，使用管理登录查看是否有和主库一样库表记录及授权用户
#     
#      #  主  select * from db5.b;
#      #  从  select * from db5.b;               
#         
#   
#2.4.4 客户端使用主库的授权用户,连接从库服务器，也可以看到新建的库表及记录
#
#
#         三、mysql主从同步的工作原理
#         从库数据库目录下的文件：
#         master.info  记录主库信息
#         主机名-relay-bin.XXXXXX  中继日志文件，记录主库上执行过的sql命令
#         主机名-relay-bin.index 索引文件，记录当前已有的中继日志文件
#         relay-log.info  中继日志文件，记录当前使用的中继日志信息
#         
#         从库IO线程 和SQL线程的作用？
#         IO线程  把主库binlog日志里的sql命令记录到本机的中继日志文件
#         SQL线程  执行本机中继日志文件里的sql命令，把数据写进本机。
#IO线程报错原因： 从库连接主库失败（ping   grant   firewalld  selinux）
#                           从库指定主库的日志信息错误（日志名   偏移量）
#
#  Last_IO_Error: 报错信息
#
#
#          修改步骤：
#
#           stop  slave;
#           change  master  to   选项="值";
#           start  slave;
#
#          SQL线程报错原因： 执行本机中继日志文件里的sql命令,用到库或表在本机不存在。
#
#            Last_SQL_Error: 报错信息
#            
#            设置从库暂时不同步主库的数据？
#            在从库上把slave 进程停止 
#
#            stop  slave;
#            
#          把从库恢复成独立的数据库服务器？
#
#             rm -rf  /var/lib/mysql/master.info 
#             systemctl  restart mysqld
#             rm  -rf   主机名-relay-bin.XXXXXX   主机名-relay-bin.index   relay-log.info
#
#     mysql主从同步结构模式
#
#           一主一从  
#           一主多从  
#           主从从
#           主主结构（又称作互为主从）
#
#     mysql主从同步常用配置参数
#
#           主库服务器在配置文件my.cnf 使用的参数
#
#           vim /etc/my.cnf
#           [mysqld]
#           binlog_do_db=库名列表   #只允许同步库Binlog_Ignore_DB=库名列表    #只不允许同步库
#           systemctl  restart  mysqld
#           
#     从库服务器在配置文件my.cnf 使用的参数
#
#           vim /etc/my.cnf
#           [mysqld]
#           log_slave_updates
#
#           级联复制
#
#           relay_log=中继日志文件名
#           replicate_do_db=库名列表   #只同步的库
#           replicate_ignore_db=库名列表   #只不同步的库
#           
#           systemctl  restart  mysqld
#           
#           配置mysql主从从结构
#           主库  192.168.4.51
#           从库  192.168.4.52 （ 做51主机从库）
#           从库  192.168.4.53 （ 做53主机从库）
#           要求：客户端访问主库51 时 创建库表记录 在52 和53 数据库服务器都可以看到
#           
#           配置步骤：
#           一、环境准备
#           主从同步未配置之前，要保证从库上要有主库上的数据。
#           禁用selinux    ]#  setenforce  0 
#           关闭防火墙服务]# systemctl  stop firewalld
#           物理连接正常 ]#  ping   -c   2   192.168.4.51/52
#           数据库正常运行，管理可以从本机登录
#           二、配置主从同步
#           2.1 配置主库51
#           用户授权
#           启用binlog日志
#           查看正在使用的日志信息
#           
#           2.2 配置从库52
#           用户授权
#           启用binlog日志，指定server_id  和 允许级联复制
#           查看正在使用的日志信息
#           验证主库的授权用户
#           管理员登录指定主库信息
#           启动slave进程
#           查看进程状态信息
#           
#           2.3  配置从库53
#           验证主库的授权用户
#           指定server_id
#           管理员登录指定主库信息
#           启动slave进程
#           查看进程状态信息
#           
#           三、客户端验证配置
#           3.1 在主库上授权访问gamedb库的用户
#           3.2 客户端使用授权用户连接主库，建库、表、插入记录
#           3.3 客户端使用授权用户连接2台从库时，也可以看到主库上新的库表记录
#           
#           
#           六、mysql主从同步复制模式 

#           异步复制
#           全同步复制
#           半同步复制
#            
#           查看是否可以动态加载模块
#           mysql> show variables like  "have_dynamic_loading";
#           
#           主库安装的模块
#           mysql> INSTALL PLUGIN rpl_semi_sync_master  SONAME 'semisync_master.so';
#           
#           从库安装的模块
#           mysql>  INSTALL PLUGIN rpl_semi_sync_slave  SONAME 'semisync_slave.so';
#           
#           查看系统库下的表，模块是否安装成功
#           mysql> 
#           SELECT   PLUGIN_NAME ,  PLUGIN_STATUS 
#           FROM   INFORMATION_SCHEMA.PLUGINS  
#           WHERE 
#           PLUGIN_NAME  LIKE   '%semi%';
#           
#           启用半同步复制模式
#           主库
#           mysql> SET GLOBAL rpl_semi_sync_master_enabled = 1;
#           
#           从库
#           mysql> SET GLOBAL rpl_semi_sync_slave_enabled = 1;
#           
#           查看半同步复制模式是否启用

#           mysql>  show  variables  like  "rpl_semi_sync_%_enabled";
#           
#           修改配置文件/etc/my.cnf 让安装模块和启用的模式永久生效。
#           
#           主库
#           vim /etc/my.cnf
#           [mysqld]
#           plugin-load=rpl_semi_sync_master=semisync_master.so
#           rpl_semi_sync_master_enabled=1
#           :wq
#           
#           
#           从库
#           vim /etc/my.cnf
#           [mysqld]
#           plugin-load=rpl_semi_sync_slave=semisync_slave.so
#           rpl_semi_sync_slave_enabled=1
#           :wq
#           
#           既做主又做从
#           vim /etc/my.cnf
#           [mysqld]
#           plugin-load = "rpl_semi_sync_master=semisync_master.so;rpl_semi_sync_slave=semisync_slave.so"
#           rpl-semi-sync-master-enabled = 1
#           rpl-semi-sync-slave-enabled = 1
#
# --------------------------------------------------------------------------------
#
#
#
#   ----------------------MYSQL-day05   数据备份与恢复-------------------------
#
#       一数据备份相关概念
#            1.1 数据备份的目的: 数据被误删除 或 设备损害导致数据丢失 ，是备份文件恢复数据。
#            1.2数据备份方式:
#
#            物理备份： 指定备份库和表对应的文件
#               
#            cp   -r   /var/lib/mysql   /opt/mysql.bak
#            cp  -r  /var/lib/mysql/bbsdb   /opt/bbsdb.bak
#            
#            rm -rf  /var/lib/mysql/bbsdb
#            cp   -r  /opt/bbsdb.bak    /var/lib/mysql/bbsdb
#            chown  -R  mysql:mysql   /var/lib/mysql/bbsdb
#            systemctl  restart  mysqld
#            
#            
#              scp  /opt/mysql.bak   192.168.4.51:/root/
#            
#              rm  -rf /var/lib/mysql
#                  cp   -r  /root/mysql.bak   /var/lib/mysql
#                  chown  -R  mysql:mysql   /var/lib/mysql
#                  systemctl  restart  mysqld
#           
#     重新初始化授权库，只适合 没有存储数据的数据库操作
#
#
#            systemctl stop mysqld
#            rm -rf /var/lib/mysql
#            systemctl start mysql
#      
#
#
#
#
#------------------
#
#
# 
#            逻辑备份： 在执行备份命令时，根据备份的库表及数据生成对应的sql命令，把sql存储到指定的文件里。
#            
#
#
#
#               数据备份策略:
#               完全备份  备份所有数据（一张表的所有数据  一个库的所有数据  一台数据库的所有数据）
#               
#               备份新产生数据（差异备份 和 增量备份  都备份新产生的数据 ）
#               差异备份 备份自完全备份后，所有新产生的数据。
#               增量备份 备份自上次备份后，所有新产生的数据
#
#
#                          18：00  t1   文件名    数据
#
#                 1 完全            10   1.sql     10            
#                 2 差异             5   2.sql      5               
#                 3                  7   3.sql     12                 
#                 4                  2   4.sql     14                 
#                 5                  1   5.sql     15              
#                 6                  3   6.sql     18             
#                 7 差异             9   7.sql     27
#
##---------                18：00  t1   文件名    数据
#
#                 1 完全            10   1.sql     10            
#                 2 增量             5   2.sql      5               
#                 3                  7   3.sql      7                 
#                 4                  2   4.sql      2                 
#                 5                  1   5.sql      1              
#                 6                  3   6.sql      3             
#                 7 增量             9   7.sql      9
#
#
#
#
#   ---        完全备份与完全恢复
#                    完全备份数据命令
#                    man mysqldump
#                    mysqldump  -uroot  -p密码  数据库名   >  目录名/文件名.sql
#           
#                    目录名  要事先创建好
#                        数据库名的表示方式？
#                        库名  表名                          备份一张表的所有数据  
#                        库名                                  备份一个库的所有数据  
#                        --all-databases  或  -A     备份一台数据库服务器的所有数据
#                        -B 库名1  库名2  库名N      把多个库的所有数据备份到一个文件里
#           
#                    完全恢复数据命令
#                         mysql  -uroot  -p密码  数据库名   <  目录名/文件名.sql
#
#
#
#        完全备份数据
#              mkdir  -p /mydatabak
#              mysqldump -uroot -p654321  studb > /mydatabak/studb.sql
#              mysqldump -uroot -p654321  db3 user3 > /mydatabak/db3-user3.sql
#             
#              cat /mydatabak/studb.sql
#              cat  /mydatabak/db3-user3.sql
#             
#        完全恢复数据
#
#              mysql -uroot -p654321  studb  < /mydatabak/studb.sql 
#              mysql -uroot -p654321  db3   < /mydatabak/db3-user3.sql
#             
#          使用source 命令恢复数据
#
#             mysql> create database  bbsdb;
#             mysql> use bbsdb;
#             mysql> source  /mydatabak/studb.sql
#
#每周一晚上18:00备份studb库的所有数据到本机的/dbbak目录下，备份文件名称要求如下  日期_库名.sql。
#
#          vim /root/bakstudb.sh
#          #!/bin/bash
#          day=`date +%F`
#          if [ ! -e /dbbak  ];then
#               mkdir /dbbak
#          fi
#          mysqldump  -uroot  -p654321  studb  >  /dbbak/${day}_studb.sql
#          
#           chmod   +x   /root/bakstudb.sh
#          /root/bakstudb.sh
#           ls /dbbak/*.sql
#          
#          crontab  -e
#          00  18   *  *  1        /root/bakstudbT CHARSET=utf8.sh  &> /dev/null#
#
#
#           完全备份的缺点:
#           数据量大时，备份和恢复数据都受磁盘I/O
#           备份和恢复数据会给表加写锁
#           使用完全备份文件恢复数据，只能把数据恢复到备份时的状态。完全备份后新
#           
#           写入的数据无法恢复
#
#
#           实时备份
#
#          增量备份与增量恢复
#
#                 启动mysql数据库服务的binlog日志文件 实现实时增量备份
#
#                 binlog日志介绍
#
#                       是mysql数据库服务日志文件的一种，默认没有启用。记录除查询之外的sql命令,二进制日志。
#
#
#                        查询命令例如： select   show   desc  
#
#                        写命令例如： insert   update   delete   create  drop 
#
#
#
#                 启用binlog日志
#
#                         vim /etc/my.cnf
#                         [mysqld]
#                         server_id=51
#                         log-bin
#                         binlog-format="mixed"
#                         
#                          systemctl  restart  mysqld
#                         
#                          ls /var/lib/mysql/主机名-bin.000001   日志文件
#                          cat  /var/lib/mysql/主机名-bin.index  日志索引
#                         
#                        my "show  variables like 'binlog_format';"
#
#
#
#
#
#                 查看binlog日志文件内容
#
#
#                   my "insert into usertab(name,uid) values('lily',56),
#                      ('bob',65);"
#
#                   my "insert into usertab(name,uid) values('huni',65);"                     
#                   my "delete from usertab  where name='lily';" 
#
#                    mysqlbinlog  /var/lib/mysql/host54-bin.000001
#
#
#
#                 binlog日志记录sql命令方式
#               
#           使用binlog日志恢复数据
#
#                命令格式
#                mysqlbinlog  日志文件名   |  mysql  -uroot  -p密码
#
#
#                mysqlbinlog [选项] 日志文件名   |  mysql  -uroot  -p密码
#      
#       binlog日志记录sql命令方式
#
#                记录方式有2种：  偏移量   、记录sql命令执行的时间
#                
#                指定偏移量范围选项 
#                --start-position=偏移量的值  
#                --stop-position=偏移量的值
#                
#                指定时间范围选项
#   180913 19:32:26             --start-datetime="yyyy-mm-dd  hh:mm:ss"  
#   180913 19:33:00             --stop-position="yyyy-mm-dd  hh:mm:ss" 
#           
#        my "delete from teadb.usertab where name in ('bob','hini');"
#  
#                    
#       mysqlbinlog --start-position=300 --stop-position=766 /var/lib/mysql/host54-bin.000001  |  mysql
#
# 
#             mysqlbinlog /var/lib/mysql/host54-bin.000001  > binlog.txt
#
#             awk '/lily/{print NR}' binlog.txt
#             36
#             69
#             118
#             awk 'NR==32{print $3}'  binlog.txt
#
#             akw '/huni/{print NR}' binlog.txt
#             53
#             102
#             135
#             awk 'NR==58{print $3}'  binlog.txt
#
#            管理日志文件 (大小超500M，生成新的文件)
#
#                   mkdir /mybinlog
#                   chown mysql /mybinlog/
#                   vim /etc/my.cnf
#                    [mysqld]
#                    server_id=54
#                    # log-bin
#                    # log-bin=db54
#                    log-bin=/mybinlog/db54
#                    binlog_format="mixed"
#         
#                    ls /mybinlog/
#                    db54.000001  db54.index
#
#
#                 手动生成新的日志文件方法
#
#                    my "show master  status;"  
#
#                    my "flush logs;"
# 
#                    ls  -l /mybinlog/
#
#                     systemctl restart mysqld
# 
#                     my "show master  status;"  
#                     
#                    mysql -e "flush logs"
#
#                    mysqldump   --flush-logs teadb   > /opt/haha.sql
#  
#                    my "show master status;"                             
# 
#  ----------------------- 
#  
#               my "flush logs;"
#               my "create database gamedb;"
#               my "create table gamedb.user(
#                   id int);"
#               my "insert into gamedb.user values(888);"
#               my "insert into gamedb.user values(888);"
#               my "insert into gamedb.user values(888);"
#               my "insert into gamedb.user values(888);"
#               my "flush logs;"
#               my "show master status;"
#
#               ls /mybinlog/
#               db54.000001  db54.000003  db54.000005  db54.000007
#               db54.000002  db54.000004  db54.000006  db54.index
#               my "drop database  gamedb;"
#       
#               mysqlbinlog  /mybinlog/db54.000006  | mysql
#    
#               my "select * from gamedb.user;"
#
#
#
#
#
#
#                 删除已有的binlog日志文件
#
#
#                删除所有的binlog日志，重新建日志
#
#                  my "reset master;"
#
#                删除早于指定版本的binlog日志
#
#
#                 my "purge master logs to 'binlog文件名'"
#
#                
#           安装第3方软件percona,提供备份命令innobackupex，对数据做增量备份
#
#                软件介绍
#                安装软件
#                备份命令的使用格式
#                完全备份 与恢复
#                增量备份与恢复
#                增量备份的工作过程
#                恢复完全备份中的当表
#
#3.2  安装第3方软件提供备份命令，对数据做增量备份软件介绍 Percona 开源软件  在线热备不锁表  适用于生产环境。
#
#        安装软件
#            rpm -ivh  libev-4.15-1.el6.rf.x86_64.rpm
#            yum -y  install   perl-DBD-mysql   perl-Digest-MD5
#            rpm  -ivh  percona-xtrabackup-24-2.4.7-1.el7.x86_64.rpm
#            rpm  -ql  percona-xtrabackup-24
#
#        提供2个备份命令
#            /usr/bin/innobackupex命令集成了命令xtrabackup，所以可以支持MYISAM存储引擎
#            
#            /usr/bin/xtrabackup命令仅支持InnoDB和XtraDB存储引擎的表
#            
#            innobackupex备份命令的使用格式？
#            innobackupex  <选项>
#             man  innobackupex
#
#                    常用选项:
#                    --user  用户名
#                    --password  密码
#                    --databases="库名"     
#                                        "库名1  库名2"
#                                        "库名.表名"
#                    --host    主机名
#                    --port    端口号
#                    --no-timestamp  不使用时间戳做备份文件的子目录名
#
#          innobackupex完全备份 与 完全恢复
#
#           innobackupex  --user  root   --password   654321  \
#           --databases="mysql   performance_schema  sys   gamedb"   /allbak  --no-timestamp
#
#             完全恢复   
#                   
#                   --copy-back
#             systemctl stop mysqld
#             rm   -rf  /var/lib/mysql
#
#             mkdir  /var/lib/mysql
#
#             innobackupex  --user root --password 654321  --copy-back  /allbak 
#
#             chown  -R  mysql:mysql  /var/lib/mysql
#
#             systemctl  restart  mysqld
#
#             mysql   -uroot  -p654321
#
#             show  databases;
#             select  * from  gmaedb.t1;
#
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#
#      my "create database db5;"
# 
#      my "create table db5.a(
#      id int(5) );"
#
#      my "insert into db5.a  values(666);"
#
#      my "show databases;"
#
# innobackupex   增量备份 与 恢复
#
# 备份：
#
# 第一次备份 备份所有数据
#
# innobackupex --user root --password Azsd1234. /fullbak --no-timestamp
#
#  写入新数据
#
# my "insert into db5.a values(888);"
#
# my "select * from db5.a;"
#
#  增量备份
#
#  --incremental 指定备份文件夹
#
#  --incremental--basedir=  指定基准文件夹   
#
#  innobackupex --user root --password Azsd1234. \
#    --incremental /zengdir --incremental-basedir=/fullbak --no-timestamp
#
#     ls /fullbak
#     echo 
#     ls /fullbak/db5/
#     echo 
#     ls /zengdir
#     echo 
#     ls /zengdir/db5
#
#   插入新数据
#
#    my "insert into db5.a values(999);"
#
#   增量备份
#
#    innobackupex --user root --password Azsd1234.  --incremental /zeng2dir  --incremental-basedir=/zengdir --no-timestamp
#
#    ls /zeng2dir
# 
#    ls /zengdir
#
#   增量备份的工作过程
#
#     在线热备不锁表 对innodb存储引擎的表 增量备份
#
#     事务日志文件
#
#       ibdata1      
#       ib_logfile0   
#       ib_logfile1
#
#    日志序列号  LSN
#
#  xtrabackup_checkpoints  (记录备份类型 和lsn范围) 
#
#  cat /fullbak/xtrabackup_checkpoints
#  cat /zengdir/xtrabackup_checkpoints
#  cat /zeng2dir/xtrabackup_checkpoints 
#
#
#       ibdata1  
# 
#             systemctl stop mysqld
#             rm -rf /var/lib/mysql/*
#             innobackupex --user root --password Azsd1234. --apply-log --redo-only /fullbak/
#             
#             innobackupex --user root --password Azsd1234. --apply-log --redo-only /fullbak/ \
#              --incremental-dir=/zengdir 
#             
#             innobackupex --user root --password Azsd1234. --apply-log   /fullbak/ \
#              --incremental-dir=/zeng2dir 
#             
#             innobackupex --user root --password Azsd1234. --copy-back /fullbak/
#             
#             chown -R mysql:mysql /var/lib/mysql
#             
#             systemctl start mysqld
#
#   
#
#   恢复
#
#        准备恢复数据
#
#        合并日志
#
#        把备份数据copy 到数据库目录下
#
#        修改权限
#
#        启动服务
#
#
# 使用完全备份文件恢复单个表
#
#          my "create table db5.b(
#              name char(10));"
#  
#          my "insert into  db5.b values('bob');"
#   
#          my "select * from db5.b"
#
#          my "desc db5.b;"
#
#          innobackupex   --user root --password Azsd1234. --databases="db5"  /db5full --no-timestamp 
#
#          my "drop table db5.b;"
#
#     恢复表
#
#           导出表信息
#          ls /db5full/db5
#          innobackupex --user root --password Azsd1234. --databases="db5" --apply-log --export /db5full
#          ls /db5full/db5
#
#
#
#           创建删除的表
#
#           my "create table db5.b(
#name char(10));"
#           删除表空间  存储数据的表文件  表.idb 
#
#           my "alter table db5.b
#discard tablespace;"
#           copy表信息文件到数据库目录下
#
#             cp /db5full/db5/b.{exp,ibd,cfg}  /var/lib/mysql/db5/
#
#           修改权限
#
#             chown -R  mysql:mysql /var/lib/mysql/db5/
#
#
#           导入表信息
#         
#             my "alter table db5.b
#                 import tablespace;"
#
#
#             my "select * from db5.b;"
#
#             rm -rf /var/lib/mysql/db5/b.{cfg,exp}
#
# --------------------------------------------------------------
#
#
#
#                
#
#------------------------------------------------------------------------------
#
#
#
#   ------------------------MYSQL-day04  MYSQL 用户授权与权限撤销--------------
#
#      管理员密码管理
#           恢复数据库管理员本机登录密码
#
#                systemctl stop mysqld
#
#                sed -i '/\[mysqld]/a skip-grant-tables'  /etc/my.cnf
#
#                systemctl start mysqld 
#
#                mu=mysql.user
#
#                my "select host,user,authentication_string,password_last_changed from $mu;"
#
#                my "update $mu set authentication_string=password('Azsd1234.')
#                where ${mu}.user='root' and ${mu}.host='localhost';flush privileges;"
#
#                sed -i '/^skip-grant/s/^s/#s/'   /etc/my.cnf
#
#                systemctl restart mysqld
#
#
#
#      修改数据库管理源本机登录的密码（需要知道当前登录的密码）
#
#         mysqladmin   -hlocalhost  -uroot   -p   password  "新密码"
#
#         mysqladmin -hlocalhost -uroot -p password "Azsd1234."
#
#         Enter password:本机登录的密码
#     
#
#
#
#         用户管理： 在数据库服务器上添加连接用户，添加时可以设置用户的访问权限,客户端地址和连接的密码。
#
#       默认只允许数据库管理员root用户在本机登录。默认只有数据库管理员root用户在本机登录才有授权权限。
#
#        用户授权
#
#          用户授权命令的语法格式
#               mysql>  grant   权限列表  on  库名.表名（*.*）   to  用户名@"客户端地址"(%)    
#           identified   by  "密码"   [with  grant  option];
#
#                 权限列表的表示方式：
#                 all  所有权限
#                 select , insert,update(字段1，字段2) 
#                 usage  连上无权限
#
# 
#                 库名.表名  的表示方式
#                 *.*            所有库所有表
#                 库名.*       某个库
#                 库名.表名  某张表
#                
#
# 
#                 用户名的表示方式：
#                 连接数据库服务器是使用的名字
#                 授权时自定义，要有标识性
#                 名字存储在mysql库下的user表里
#                 
#                 客户端地址的表示方式：
#                 %                     所有地址
#                 192.168.4.254         指定ip地址
#                 192.168.4.%           网段
#                 pc254.tedu.cn         主机名(要求数据库服务器可以解析主机名)
#                 %.tedu.cn             域名(要求数据库服务器可以解析域名内的主机名)
#                 
#                 identified   by  "密码"   授权用户连接数据库服务器密码自定义即可
#                 
#                 with  grant  option 可选项，让新添加的授权用户有授权的权限。
#
#                 授权用户连接后修改密码
#                           
#                          set password=password('')
#
#                 管理员  
#                          set password 
#                                for user @'host'=password('')
#  -----
#
#                 my "grant all on *.* to mydba@'%' identified by 'Azsd1234.' with grant option;"
#
#                 my "grant select,insert on teadb.* to admin@'192.168.4.57' identified by 'Azsd1234.' ;"
#                  my "select user();"
#
#                  my "select @@hostname;"
#
#                  my "show grants;"
#
#        相关命令
#                   select   user(); 显示连接用户名和客户端地址
#                   select  @@hostname  ;   查看当前登录的主机名
#                   show   grants  ;   登录用户查看自己的访问权限
#                   select user,host from mysql.user; 查看当前已有的授权授权
#                   show grants  for  用户名 @“客户端地址”；查看已有授权用户的访问权限
#                   drop  user   用户名 @“客户端地址";  删除授权用户
#
#          撤销用户权限命令的语法格式
#
#             ------划重点
#             撤销的是用户的访问权限
#             用户对数据库有过授权才可以撤销
#         
#          语法格式  revoke  权限列表  on  数库名  from 用户名@"客户端地址" ;
#         
#         
#                 my "select user,host from mysql.user;"
#
#                 my "revoke select,update on *.* from myadm@'%';"
#
#                 my "revoke all on  *.* from mydba@'%';"                
#
#                 my "show grants for  mydba@'%'; "
#
#                 my "revoke grant option on *.* from mydba@'%';"
#
#                 my "drop  user mydba@'%';"
#         
#          数据库服务器使用授权库存储授权信息
#
#              mysql库   授权库   存储授权信息
#              user   存储授权用户的名及访问权限
#              db      存储授权用户对库的访问权限
#              tables_priv  存储授权用户对表的访问权限
#              columns_priv  存储授权用户对字段的访问权限
#              
#              information_schema 虚拟库 不占用物理存储空间 数据存储在物理内存里
#                                           存储已有库和表的信息
#         
#         
#         
#       
#
#
#
#  my "grant all on db5.* to yaya@'192.168.4.51' identified by 'Azsd1234.' with grant option; "
#  my "grant insert on mysql.* to yaya@'192.168.4.51';"
#
#         my "use mysql;show tables;"
#         
#         my "desc mysql.user;"
#         
#         my "select * from mysql.user where user='yaya'\G;"
#         
#         my "desc mysql.db;"
#         
#         my "select host,db,user from mysql.db;"
#         
#         my "select * from mysql.db where user='yaya'\G;"
#
#         my "update mysql.db set Insert_priv='N' where user='yaya' and host='192.168.4.51' and db='db5';flush privileges;"
#      
#         my "show grants for yaya@'192.168.4.51';"
#           
#         my "select * from mysql.db where user='yaya'\G;"
#
#
#
#
#
#
#
#
#
#
#
#
#          工作中如何授权:
#         给管理者授权     给完全权限 且有授权权限
#         给使用者授权     只给select  和  insert 权限  
#
#               命令        权限
#               
#               usage      无权限
#               
#               SELECT     查询表记录
#               
#               INSERT     插入表记录
#               
#               UPDATE     更新表记录
#               
#               DELETE     删除表记录
#               
#               CREATE     创建库、表
#               
#               DROP       删除库、表
#               
#               RELOAD     有重新载入授权 必须拥有reload权限，才可以执行flush [tables | logs | privileges] 
#               
#               SHUTDOWN   允许关闭mysql服务 使用mysqladmin shutdown 来关闭mysql
#               
#               PROCESS    允许查看用户登录数据库服务器的进程 （  show  processlist;  ）
#               
#               FILE       导入、导出数据
#               
#               REFERENCES 创建外键
#               
#               INDEX      创建索引 
#               
#               ALTER      修改表结构
#               
#               SHOW DATABASES     查看库
#               
#               SUPER     关闭属于任何用户的线程
#               
#               CREATE TEMPORARY TABLES       允许在create  table 语句中使用  TEMPORARY关键字
#               
#               LOCK   TABLES                 允许使用  LOCK   TABLES  语句
#               
#               EXECUTE  执行存在的Functions,Procedures 
#               
#               REPLICATION SLAVE    从主服务器读取二进制日志
#               
#               REPLICATION CLIENT   允许在主/从数据库服务器上使用 show  status命令
#               
#               CREATE VIEW  创建视图
#               
#               SHOW VIEW    查看视图
#               
#               CREATE ROUTINE 创建存储过程
#               
#               ALTER ROUTINE  修改存储过程
#               
#               CREATE USER    创建用户
#               
#               EVENT          有操作事件的权限
#               
#               TRIGGER,  有操作触发器的权限
#               
#               CREATE TABLESPACE  有创建表空间的权限
#
#
#
# -----------------------------------------------------------------------------
#   ------------------------MYSQL-day04  MYSQL 管理方式-----------------------------
# 
#   图形管理工具phpmyadmin
#
#       
#
#
#
#
#  --------------------------------------------------------------------------------
#
#   ------------------------MYSQL-day04  多表查询----------------------------------
#
#        复制表
#        作用:  备份表   和 快速建表
#        命令格式:   create   table   库.表   sql查询命令；
#
#          -------划重点
#        复制的内容由sql查询命令决定
#        不会复制源表字段的键值给新表
#         my "create database stu default character set utf8;"
#         my "create table stu.user1 
#select * from teadb.usertab;"
#         my "create  table stu.user2
#select * from teadb.usertab where 1=2;"
#          my "alter  table  stu.user2 
#add id int(2) primary key auto_increment first; "
#         my "alter table  $x
#add index(name) ;"
#   
#  
#          my "desc $x;"
#         
#        多表查询（连接查询）
#
#        将2个或两个以上的表 按某个条件连接起来，从中选取需要的数据
#
#        当多个表中 存在相同意义的字段时，可以通过该字段连接多个表
#
#
#        --多表查询
#
#    
#命令格式:   select   字段名列表  from  表名列表  [ where  匹配条件]；
#例子:
#               my "create table stu.t1
#                   select name,uid,shell from teadb.usertab  limit 3;"                 
#               my "create table stu.t3
#                  select name,gid,homedir from teadb.usertab  limit 6;"                 
#               my "drop table stu.t1;"
#t1=stu.t1
#t3=stu.t3
#               my "select * from stu.t1;"
#               my "select * from stu.t2;"
#   笛卡尔集    my "select * from stu.t1,stu.t3;"
#
#               my "select stu.t1.name ,stu.t3.name from stu.t1,stu.t3;"
#               my "select * from stu.t1,stu.t3  where stu.t1.name=stu.t3.name;"
#               my "select * from stu.t1,stu.t3 where stu.t1.name='root';"
#               my "select * from stu.t1,stu.t3 where stu.t1.name='root' and stu.t3.name='root';"
#               my "select * from stu.t1,stu.t3,teadb.usertab where stu.t1.name='root' and stu.t3.name='root' and teadb.usertab.name='root';"
#                my "select * from $t1,$t3;"
#
#
#      where嵌套查询
#      定义：  把内层的查询结果作为外层查询的查询条件
#      命令格式： 
#     select  字段名列表   from   库.表   条件  (  select  字段名列表   from   库.表   条件   );    
#例子：
#   tu=teadb.usertab
#            my "select name,shell from $tu where uid < (select avg(uid) from $tu);"
#            my "select *  from  $tu where name in (select name from $t3);"
#            my "select *  from  $tu where name in (select name from $t1);"
#            my "select name from $tu where name in (select name from $t3 where shell='/bin/bash');"
#            
#        连接查询  比较相同表结构里数据的差异
#
#          左连接查询 （当匹配条件成立时 以左表为主显示查询记录）
#            select  字段名列表  from   表A  left  join  表B   on  匹配条件； 
#
#          右连接查询（当匹配条件成立时 以右表为主显示查询记录）
#            select  字段名列表  from   表A  right  join  表B   on  匹配条件； 
#t3=teadb.t3
#t4=teadb.t4
#tu=teadb.usertab
#            my "create table $t3
#                select  name,uid,shell from $tu limit 5;"
#            my "create table $t4
#                select  name,uid,shell from $tu limit 9;"
#            my "select * from $t3 left join $t4 on $t3.uid=$t4.uid;"
#            my "select * from $t3 right join $t4 on $t3.uid=$t4.uid;"
#              
#
#
#
#
#
#
#
#
#
#
#  -------------------------------------------------------------------------------
#
#                          ------------------第三天 mysql 匹配条件 ---------------
#
# 基本匹配条件，高级匹配条件， 应用于 select，update ，delete
#
# 用于数据数值类型  
#
#    =      等于
#    >,>=   大于，大于等于
#    <,<=   小于，小于等于
#    !=     不等于
#   
#     my "select id,name,uid,gid,shell from pafo.user2 where uid=gid;"
#
#     my "select id,name,uid,gid,shell from pafo.user2 where 1=2;"
# 
#     my "select id,name,uid,gid,shell from pafo.user2 where id!=2  and  uid!=2;"
#      
#     my "select id,name,uid,gid,shell from pafo.user2 where id>=42;"
#
#   字符比较/匹配空/非空   
#   
#           =             相等 
#
#           !=            不相等 
#
#           is   null     匹配空
#
#           is   not null 匹配非空
#
#     my "select * from pafo.user2 where name='root';"
#
#     my "select * from pafo.user2 where name!='root';"
#
#     my "select * from pafo.user2 where uid  is  null;"
#
#     my "select * from pafo.user2 where uid  is not  null;"
#
#     逻辑比较
#
#             or    逻辑或
#
#             and   逻辑与
#
#             ！    逻辑非
#
#            （）   提高优先级
#
#     my "select  id,name,uid,gid,shell from  pafo.user2 where  id=56 or id=2 or name='lisi';"
#
#    范围内匹配
#
#    in（）        在   里
#
#    not  in （）  不在  里
#
#    between 数字1 and 数字2   在   之间
#
#    distinct 字段名   去重显示
#
#     my  "select id,name,uid,gid,shell from pafo.user2
#          where id in(1,2,3,4);"
#
#     my  "select id,name,uid,gid,shell from pafo.user2
#          where id not in(1,2,3,4);"
#
#
#     my  "select id,name,uid,gid,shell from pafo.user2
#          where name not in('root','lisi');"
# 
#     my  "select  shell from pafo.user2 where id<=20;" 
#
#     my  "select   id,name  from pafo.user2 where  id between 3 and 6; "
# 
#     my  "select   distinct  shell   from pafo.user2  where  id<=20;"
#
#
#    模糊匹配
# 
#    where 字段  like  '表达式'
#
#    %   表示零个或多个字符
#
#    _    表任意一个字符
#
#   binary  区分大小写   
#
#         my "select name from teadb.usertab where name='RoOt';"  
#         my "select name from teadb.usertab  where binary name='Root'; "
#    
#
#    my "select name from teadb.usertab  where name like '%____%';" 
#    my "select name from teadb.usertab  where name like '____';"
#    my "select name from teadb.usertab  where name like '%a%';"
#
#     正则匹配
#
#     字段名   regexp  '正则表达式' 
#
#     ^   $    .    *   [  ]
#
#        my "insert into teadb.usertab(name,uid)  values('2re1d',1552),
#     ('1re2d',1553);"
#
#        my "select name from teadb.usertab where name  regexp '[0-9]';"
#
#        my "select name from teadb.usertab where name regexp '^[0-9]';"
#
#        my "select name from t1 where name  not regexp '[0-9]';"
#
#        my "select name from teadb.usertab where name regexp 'a$';"
#
#        my "select name from teadb.usertab where name regexp '....';"
# 
#        my "select name from teadb.usertab where name regexp '^....$';"
#
#
#        my "select name from teadb.usertab where name regexp '^r|d$';"
#
#     四则运算(select 和 update 操作是可以做数学计算)
#
#           my "alter table  teadb.usertab  add   age tinyint(1) default 18 after name;"
#           my "alter table  teadb.usertab add  n_year  year(4) default 2018  after age;"
#           my "select year(now());" 
#           my "desc teadb.usertab;"
#           my "select name,age,n_year-age from teadb.usertab;"
#           my "select name,age,2018-age as s_year from teadb.usertab  where name='root'; "      
#           my "select name,age from teadb.usertab;"
#           my "select name,uid,gid,sum(uid+gid) as haha  from teadb.usertab where name='bin'group by uid,gid;"
#           my "select name,uid from teadb.usertab  where uid % 2 = 0 ;"
#           my "select name,uid,gid,(uid+gid)/2 pjs from teadb.usertab where name='root';"
#           my "update teadb.usertab set age=age+1;"
#           my "update teadb.usertab set age=age+1 where name='root';"
#           my "select name,age from teadb.usertab ;"  
#
#
#           count(字段名）统计字段值的个数
#           sum(字段名）  求和
#           max(字段名）  输出字段值的最大值
#           min(字段名）  输出字段值的最小值
#           avg(字段名）  输出字段值的平均值
#
#            my "select count(*) from teadb.usertab;"
#  
#            my "select sum(uid) from teadb,usertab;"
#
#            my "select count(name) from teadb.usertab where shell='/bin/bash';"
#
#            my "select name,min(uid) as min   from  teadb.usertab group by uid,name limit 1;"
#                      
#            my "select max(uid) from teadb.usertab;"
#  
#            my "select avg(age) from teadb.usertab;"
#
#
#
#               
#     查询分组
#
#     sql查询   group   by  字段名；
#
#      my "select shell,name from teadb.usertab where uid < 500 group by shell,name;"
#
#       my "select distinct shell from teadb.usertab ;"
#    
#
#
#     查询排序 (按照数值类型的字段排队)
#
#     sql查询  order  by  字段名  asc|desc;
#  
#      my "select name,uid from teadb.usertab where uid between 10 and 1000 order by uid ;"
#
#      my "select name,uid from teadb.usertab where uid between 10 and 1000 order by uid desc;"
#
#
# 
#
#    限制查询显示行数(默认显示所有查询的记录)
#
#     sql查询  limit  数字； 显示查询结果的前几行
#     sql查询  limit  数字1，数字2；  显示查询结果指定范围的行
#
#  my "select name,uid from teadb.usertab  where uid < 100 having 500;"
# 
#  my "select name,uid from  teadb.usertab  having name='bin';"
#  my "select shell from teadb.usertab group by sehll having shell;"
#
#       my "select * from teadb.usertab limit 0,5;"
#       my "select * from teadb.usertab limit 0;"
#       my "select * from teadb.usertab limit 0,1;"
#       my "select * from teadb.usertab limit 1;"
#
#       my "select name,uid  from teadb.usertab  order by uid limit 0;" 
#
#       my "select name,uid  from teadb.usertab  order by uid limit 1;" 
#
#  ------------------------------------------------------------------------------         
#
#                          ------------------第三天 mysql 管理表记录 -------------
#
#      增加表字段
#  
#                      my "alter table pafo.user2
#                          add id int(2) primary key auto_increment 
#                          first;" 
#
#      插入记录
#
#        一条          my  "insert into  pafo.user2 values(42,'bob','x',1005,1005,' ','/home/bob','/bin/bash');"
#
#        多条          my  "insert into  pafo.user2 values(43,'haha','x',1006,1006,' ','/home/haha','/bin/bash'),
#                           (44,'haha','x',1006,1006,' ','/home/haha','/bin/bash');"
#
#                      my  "insert into pafo.user2(name)  values('lily');"
#
#      查询记录
#
#                      select * from 表名；
#
#                      select 字段名   from 表名；
#
#                      select 字段名   from (库名).表名  where  条件表达示  ；
#
#                      my "select id,name,uid from pafo.user2  where   id<=10;"
#                         
#                     
#                      my "desc pafo.user2;select * from pafo.user2;"
#
#      更新表记录
#
#      更新全部        update 表名 set 字段1=字段值1,字段2=字段值2,字段N=字段值N;
# 
#      更新满足条件的  update 表名 set 字段1=字段值1,字段2=字段值2,字段N=字段值N  where 条件表达示;  
#
#                      my "update pafo.user2 set name='jiaoben'  where id=44; "
#   
#                      my "select * from pafo.user2 where id=44;"
# 
#      删除表记录
#
#      删除全部表记录  delete from 表名；
#
#      删除符合条件的  delete  from 表名 where  条件表达示；
#
#                      my "delete from pafo.user2 where id>=45;"
#                           
#                      my "select * from pafo.user2;"
#    ----------------------------------------------------------------------------------------------------
#                          ------------------第三天 mysql 数据导入导出（批量操作数据）-----------
#         
#             数据导入：把系统文件的内容存储到数据库服务器的表里
#                       系统文件内容，不可以杂乱无章
#
#             my "show variables like 'secure_file_priv';"    # 查看默认使用目录
#             vim /etc/mmy.cnf
#             [mysql]
#             secure_file_priv="/mydir"
#       name char(10),
#       age int(2),
#       primary key(name)
#       );"
#       my "insert into game.m22 values('tom',15);"
#       my "insert into game.m22 values('tom',15);"
#       my "insert into game.m22 values('bob',15);"
#       my "insert into game.m22 values(null,15);"
#       my  "select * from game.m22;"
#
#
#       my "desc game.m21;"
#       my "desc game.m22;"
#
#        ----------------------------------
#
#
#
#
#
#
#
#
#
#
#
#         msyql   ：1，限制如何字段赋值  2. 给字段的值排队
#
#           ----delete index -------------------
#      　　DROP INDEX index_name ON talbe_name
#　      　ALTER TABLE table_name DROP INDEX index_name
#　       　ALTER TABLE table_name DROP PRIMARY KEY
#       my "select * from game.m1;
#       insert into game.m1 values('able',15,'nsd1806');
#       select * from game.m1;"
#
#        --- 查看 index -- MUL--------
#
#       my "show index from game.t26;"
#       my "desc game.t25;"
#
#              --- 创建index  -------------------------
#
#               my "create table game.m1(
#               name char(10),
#               age int(2)  ,
#        class char(7),
#        index(name),
#        index(age)
#        
#        );"
#
#        my "desc game.m1;"
#        my " show index from game.m1\G;"
#
#
#
#
#
#
#         my "show game.tables;"
#         my "create index i1 on game.t3(name);"
#         my "show index from game.t3\G;"
#         my "desc game.t3;"
#         my "select * from game.t3;"
#         my "explain  select * from game.t3 where name='abc'\G;"
#
#         ---------------------------------
#
#
#        修改表结构命令的格式
#         
#      update  game.t27 set set=no
#      my "alter table  game.t27 
#      modify sex enum('boy','girl','no') not null default 'no' ;"
#      my "alter table game.t27 
#      change email mail varchar(50) default 'stu@tedu.cn';"
#     
#      my "alter table  game.t27 
#      add class char(7) default 'nsd1806' first,
#      add qq varchar(11) after name;"
#      my "desc game.t27;"
#     my "select * from game.t27;"
#
#        --------------------------------
#
#       my "create table game.t27(
#         name char(4) not null ,
#         age  tinyint(2)  default 21,
#         sex  enum('m','w') not null default 'm'
#       );"
#       my "desc game.t27;"
#       my "insert into game.t27(name) values('bob');"
#       my "insert into game.t27  values('tom',1,'w');"
#       my "insert into game.t27 values(null,null,null);"
#       my "insert into game.t27 values('null',null,'m');"
#       my "insert into game.t27 values('',null,'m');"
#       my "insert into game.t27 values(null,null,'m');"
#       my "insert into game.t25(naem) values('tom');"
#       my "select * from game.t27;"
#       my "select * from game.t5;"   
#       my "create table game.t26(
#       naem char(3) not null,
#       age  tinyint(2) default 21,
#       sex enum('m','w') not null default 'm'
#       );"
#       mysql -uroot -p'Azsd1234.'  -e "CREATE TABLE game.t2 (
#         name char(10) DEFAULT NULL,
#         age int(3) DEFAULT NULL,
#         sex enum('male','female','trans') DEFAULT NULL
#       ) ENGINE=InnoDB DEFAULT CHARSET=utf8"
#
#       mysql -uroot -p'Azsd1234.'  -e "create table game.t3 (
#          name  char(10),
#          birthday   date,
#          meetting   datetime,
#          sttime     year,
#          sktime     time
#       ) charset=utf8"
#       $my"insert into game.t3 values('abc',curdate(),now(),50,curtime());"
#       $my"select * from  game.t3;"
#       $my'Azsd1234.' -e   "insert into game.t2 values('lucy',16,'female');"
#       $my'Azsd1234.' -e   "insert into game.t3 values('bob',20181120,20180930123000,1990,083000);"
#                                insert
#                               delete   from  t1;
#                               update  t1  set  name="bob"  where  name="lucy";
#                               update  t1  set  name="tom"  where  name="jerry";
#               锁类型
#
#               读锁  （共享锁） 支持并发读
#               写锁  （互斥锁、排他锁） 是独占锁，上锁期间其他线程不能读表或写表； 
#
#
#               查看当前的锁状态
#                 
#               my "show status;"
#               my "show status like 'Table_lock%';"
#               my "show status like '%lock%';"   
#
#               事务特性（ACID）
#
#               Atomic      : 原子性
#                             事务的整个操作是一个整体，不可分割，要幺全部成功，要幺全部失败
#
#               Consistency : 一致性
#                             事务操作的前后，表中记录没有变化
#              
#               Isolation   ：隔离性
#                             事务操作是相互隔离不受影响 
#
#               Durability  ：持久性
#                             数据一旦提交，不可改变，永久改变表数据；    
#
#                 my "show variables;"
#                 my "set autocommit=off;"  临时关闭自动提交
#                 my "show variables like 'autocommit';" 
#                 my "rollback;"   数据回滚
#                 my "commit;"     提交数据
#
#
#   ---------------------------------------------------------------------------

#           数据类型的关键字   存储范围  赋值方式  合理使用数据类型
#           *******划重点*****
#           数值类型的宽度 是显示宽度，不能够给字段赋值的大小。字段的值由类型决定。


#   ----------------------MYSQL-day02 mysql字段约束条件、修改表结构 --------------

#              一 、字段约束条件

#              1.1  作用： 限制如何给字段赋值的

#              1.2  包括内容有：  NULL    Key    Default     Extra 

#              NULL  是否允许给字段赋null值  

#                         null           默认允许赋null值    
#                         not  null   不允许赋null值

#              key     键值类型：普通索引   唯一索引  全文索引  主键  外 键

#              
#              Default 默认值 作用：当不被字段赋值时，使用默认值给字段赋值
#                           不设置默认值是  系统定义的是null
#                           default   值   
#              Extra    额外设置  ，字段是否设置为自动增加,默认没有自动增长功能
#              
#              
#              二、修改表结构
#              2.1 修改表结构的命令
#              mysql>  alter  table  库.表    执行动作 ；
#              
#              添加新字段      add   字段名    类型(宽度)  [ 约束条件]
#              
#              删除已有字段  drop   字段名
#              
#              修改已有字段的类型宽度及约束条件
#              ***划重点****  修改时不能与已经存储的数据矛盾的话不允许修改
#                                   modify   字段名    类型(宽度)  [ 约束条件]
#              
#              修改字段名
#                                 change   源字段名   新字段名   类型(宽度)  [ 约束条件]
#              
#              修改表名
#                                 alter  table  源表名  rename   [to]   新表名；
#              
#              三、mysql键值
#              设置在表中字段上的，作用是约束如何给字段赋值。同时会给字段做索引。
#              
#              索引介绍： 树状目录结构  类似与书的“目录”
#              优点：加快查询表记录的速度
#              缺点 : 会减慢编辑表记录的速度，且占用磁盘的物理存储空间
#                        (delete  insert   update)
#              
#              字典  总页面数  1000页
#              
#              目录信息  
#              1------100页     记录目录信息
#              101---1000页   正文
#              
#              查字典的方法
#              笔画
#              部首
#              拼音
#              
#              修正内容时，修改内容 添加内容  删除内容          
#              
#              
#              stuinfo   /var/lib/mysql/db2/stuinfo.*
#              name   age   home   class
#              DBA
#              
#              
#              
#              3.1 键值：普通索引   唯一索引  全文索引  主键  外 键
#                                  *                                          *        *
#              3.1.1普通索引的使用（index）
#              使用规则?
#              
#              查看
#              desc  表名;
#              show   index  from   表名;
#              Table: t2
#              Key_name: aaa
#              Column_name: age
#              Index_type: BTREE  (二叉树)
#              
#              创建
#              在已有表创建
#              create   index   索引名  on   表名（字段名）；
#              
#              
#              
#              建表是时创建
#              create  table  表名（
#              字段列表，
#              index(字段名)，
#              index(字段名)，
#              ）;
#              
#              删除
#              drop   index   索引名  on   表名；
#              
#              +++++++++++++++++++++++++++++++
#              3.1.2主键 primary   key 
#              （普通主键    复合主键    主键+auto_increment）
#              
#              使用规则?
#              
#              查看   desc   表；  key ----> PRI
#              
#              创建
#              在已有表创建     alter  table   表   add   primary  key(字段名)；
#              
#              建表时创建
#              create  table  表名（
#              字段列表，
#              primary  key(字段名)
#              ）；
#              
#              
#              创建复合主键的使用：多个字段一起做主键，插入记录时，只要做主键字段的
#              值不同时重复，就可以插入记录。
#              desc  mysql.db;
#              desc  mysql.user;
#              
#              主键primary  key  通常和auto_increment连用。
#                                                    让字段的值自动增长  i++
#                                                       数值类型               i=i+1
#              
#              
#              删除主键   mysql>  alter  table   表   drop    primary  key；
#              ++++++++++++++++++++++++++++++++++++++
#              3.1.3外 键(作用 限制如何给字段赋值的)
#              给当前表中字段赋值时，值只能在其他表的指定字段值的范围里选择。
#              
#              使用规则?
#              
#              创建外键 foreign  key 的命令格式：
#              create   table   表（
#              字段名列表，
#              foreign  key(字段名)   references  表名（字段名） 
#              on  update cascade    on  delete  cascade
#              ）engine=innodb;
#              
#              缴费表
#              use studb;
#              create  table  jfb(
#              jfb_id    int(2)  primary key  auto_increment,
#              name   char(15),
#              pay   float(7,2)
#              )engine=innodb;
#              
#              insert into  jfb (name,pay)values("bob",26800);
#              insert into  jfb (name,pay)values("tom",26000);
#              
#              select  *  from  jfb;
#              
#              班级表 
#              create  table  bjb(
#              bjb_id   int(2),
#              name   char(15),
#              foreign  key(bjb_id)   references  jfb(jfb_id) 
#              on  update cascade    on  delete  cascade
#              )engine=innodb;
#              
#              
#              insert  into   bjb values(3,"lucy");
#              insert  into   bjb values(1,"bob");
#              insert  into   bjb values(2,"tom");
#              select  * from bjb;
#              
#              mysql> update  jfb set jfb_id=9 where name="bob";
#              mysql> delete from jfb where jfb_id=2;
#              select  * from jfb;
#              select  * from bjb;
#              
#              
#              查看  mysql> show create table 表名;
#              
#              删除外键   
#              alter  table  表名  drop  foreign key  外键名;
#              alter  table  bjb  drop  foreign key  bjb_ibfk_1;
#              
#              在已有表创建  
#              mysql> delete from bjb;
#              mysql> alter  table  bjb  add  foreign  key(bjb_id)   references  jfb
#              (jfb_id)  on  update cascade    on  delete  cascade;
#              
  



#   -----------------------------------------------------------------------------------
#   ----------------------MYSQL-day01 mysql数据库管理 -----------------------------
#            相关概念问题

#            数据库介绍  存储数据的仓库
#            
#            数据库服务都那些公司在使用？ 

#            购物网站    游戏网站      金融网站           
#             
#            数据服务存储的是什么数据？

#            帐号信息   对应的数据信息
#            
#            提供数据库服务的软件有那些

#            开源软件  mysql 、  mongodb  、  redis  

#            商业软件  oracle 、 db2  、 SQL  SERVER

#            
#            软件是否跨平台 Linux    Unix     Windows

#                   
#            软件包的来源： 官网下载      使用操作系统安装光盘自带软件包
#               
#          mysql软件介绍

#            mysql   mariadb

#            关系型数据型软件： 要按照一定组织结构存储数据，并且数据和数据之间可以互相关联操作。 

#            跨平台 Linux    Unix     Windows

#            可移植性强

#            支持多种语言Python/Java/Perl/PHP
#                           
#            生产环境中，数据服务和网站服务一起使用 构建网站运行平台

#            LNMP    LAMP   WNMP    WAMP
#            
#            mysql软件包的封包类型： rpm包     源码包    可以自定义安装信息

#            +++++++++++++++++++++++++++++++

#            非关系型数据库软件（NoSQL）mongodb、redis、 memcached

#            key  =  值

#            微信名    消息内容
#            
#            day01学习内容：

#            1  搭建mysql数据库服务器


#               服务名  mysqld
#               服务的主配置文件  /etc/my.cnf
#               数据目录  /var/lib/mysql
#               日志文件   /var/log/mysqld.log


#            2  mysql服务基本使用

#            3  mysql数据类型
#            
#            一、搭建mysql数据库服务器 192.168.4.51

#                1装包
#                1 删除系统自带mariadb mysql数据库软件

#                  rpm   -qa  |  grep   -i  mariadb

#                  systemctl  stop  mariadb

#                  rpm   -e  --nodeps   mariadb-server   mariadb

#                  rm  -rf  /etc/my.cnf

#                  rm  -rf  /var/lib/mysql

#                2 安装mysql软件

#                 tar  -xf  mysql-5.7.17-1.el7.x86_64.rpm-bundle.tar

#                 ls  *.rpm

#                 rm  -rf   mysql-community-server-minimal-5.7.17-1.el7.x86_64.rpm
#                
#                 yum   -y   install    perl-JSON   

#                 rpm  -Uvh    mysql-community-*.rpm

#                 rpm  -qa   | grep  -i   mysql

#            修改配置文件(不需要修改配置文件 按默认配置运行即可)

#                 ls  /etc/my.cnf  
#            启动服务

#                 systemctl   start  mysqld
#                 systemctl   enable  mysqld
#            
#            查看服务进程和端口号

#              ps   -C   mysqld
#            
#              netstat  -utnlp  | grep  mysqld
#            


#            
#            二、数据库服务的基本使用
#            2.1 使用初始密码在本机连接数据库服务

#                mysql   [-h数据库服务器ip地址   -u用户名    -p'密码'  

#                grep password /var/log/mysqld.log

#                mysql   -hlocalhost   -uroot   -p'hqToPwaqf5,g!><'
#            
#            2.2 重置本机连接密码 

#                mysql> alter  user   
#                root@"localhost"  identified by "密码"；

#                mysql>set global validate_password_policy=0;  只检查密码的长度
#                mysql>set global validate_password_length=6;  密码长度
#                
#                不能小于6个字符
#                
#                mysql>alter  user   root@"localhost"  identified by "123456"；
#                mysql>quit
#                
#                ]# mysql   -hlocalhost   -uroot   -p123456
#                mysql>  show   databases;
#                
#                让密码策略永久生效

#                vim  /etc/my.cnf
#                [mysqld]
#                validate_password_policy=0
#                validate_password_length=6
#                :wq
#                systemctl   restart  mysqld


#            
#            2.3 把数据存储到数据库服务器上的过程？

#               连接数据库服务器（命令行   API    图形工具）
#               选择库 （存放数据的文件夹）
#               选择表 （就是文件）
#               插入记录  （文件中的行）
#               断开连接

#            2.4 sql命令分类? 

#                  DDL   DML    DTL    DCL

#            2.5 sql命令使用规则?

#            2.6 管理数据库的sql命令 及 库名的命名规则

#                查看  show  databases;
#                创建  create  database  库名；
#                切换  use  库名；  
#                删除  drop   database  库名；   
#                显示当前所在的库      select  database();

#            2.7 管理表的 sql命令

#                建表的语法格式？
#                create   table  库名.表名（
#                字段名   类型（宽度）  约束条件，
#                字段名   类型（宽度）  约束条件，
#                .....
#                ）;
#            
#            2.8  管理记录的sql命令

#            查看   select   *  from   库名.表名   ; 

#            插入   insert    into   库名.表名  values(字段值列表);

#            insert into  gamedb.stuinfo values ("tom","beijing");
#            insert into  gamedb.stuinfo values ("bob","beijing");
#            
#            修改  update  库名.表名  set   字段名=值 where  条件；

#            update  gamedb.stuinfo  set  addr="shanghai" where 
#            
#            name="tom";
#            
#            删除
#            delete  from   库名.表名;
#            delete  from  gamedb.stuinfo;


#            +++++++++++++++++++++++++

#            三、mysql数据类型

#            3.1  数值类型   （成绩  年龄   工资  ）

#            每种类型的存储数据的范围都是固定

#            整数类型 （只能存储整数）

#            微小整型    小整型         中整型                   大整型    极大整型

#            tinyint      smallint      MEDIUMINT        INT        bigint

#            *****unsigned    使用数值类型有符号的范围。
#            
#            浮点型 （存储小数）

#            float(M,N)     
#            double(M,N)
#            
#            M  设置总位数
#            N   设置小数位位数
#            
#            正数.小数          总位数   整数位    小数位
#            18088.88            7           5             2                           
#            
#            3.2  字符类型   （商品名称   籍贯   姓名   生产厂家）

#            char  (255)   固定长度字符类型
#            varchar (65532)   变长字符类型
#            
#            大文本类型 （音频文件 视频文件  图片文件）

#            blob
#            text
#            
#            3.3 日期时间类型 

#            （注册时间    约会时间   开会时间   入职时间   生日）
#            
#            年       year   YYYY            2018
#            日期     date   YYYYMMDD        20180423
#            时间     time   HHMMSS          161958
#            日期时间 datetime/timestamp   YYYYMMDDHHMMSS     20180423161958
#            
#            获取日期时间给对应的日期时间类型的字段赋值
#            获取日期时间函数
#            now() 获取当期系统的时间
#            year(日期时间)获取指定时间中的年
#            month(日期时间)获取指定时间中的月
#            date(日期时间)获取指定时间中的日期
#            day(日期时间)获取指定时间中的号（天）
#            time(日期时间)获取指定时间中的时间
#            
#            可以使用2位数字给year类型的字段赋值，规律如下：

#            01-69   20XX
#            70-99   19XX
#            
#            datetime与timestamp 的区别？
                  
                 
#            
#            3.4 枚举类型（插入记录 时 记录的值 在列举的范围内选择）

#                                  性别    爱好    专业
#            
#            enum(值列表)          单选
#            set(值列表)           多选                  
#            



# ------------------------------------------------------------------------
#
#    把/etc/passwd文件的内容存储到teadb库下的usertab表里，并做如下配置：
#
#          my "create database teadb default character set=utf8;"
#          my "create table teadb.usertab(
#              name char(30),
#              password char(1),
#              uid int(2),
#              gid int(2),
#              comment char(150),
#              homedir char(30),
#              shell char(30),
#              index(name) 
#              );"
#
#
#                cp /etc/passwd /var/lib/mysql-files/
#                
#                my "load data   infile '/var/lib/mysql-files/passwd'
#                    into table teadb.usertab 
#                    fields terminated by ':'
#                    lines terminated by '\n';"
#                    
#
#   6 在name字段下方添加s_year字段 存放出生年份 默认值是1990
#             
#                my "alter table teadb.usertab 
#                    add s_year year(4) default 1990 after name;"
#
#
#   7 在name字段下方添加字段名sex 字段值只能是gril 或boy 默认值是 boy  
#
#                my "alter table teadb.usertab
#                    add sex enum('boy','girl') default 'boy' after name;"
#                 
#   8 在sex字段下方添加 age字段  存放年龄 不允许输入负数。默认值 是 21 
#
#                my "alter table teadb.usertab
#                    add age int(2) unsigned default 21 after sex;"
#
#   9 把id字段值是10到50之间的用户的性别修改为 girl
#
#                my "alter table teadb.usertab
#                    add id int(2) primary key auto_increment first;"
#
#                my "update teadb.usertab set sex='girl' where id between 10 and 50;"
#
#   10 统计性别是girl的用户有多少个。
#
#                 my "select count(*) from teadb.usertab where sex='girl';"
#
#   12 查看性别是girl用户里 uid号 最大的用户名 叫什么。
#
#                 my "select name from teadb.usertab where sex='girl' order by uid desc limit 1;   "
#
#   13 添加一条新记录只给name、uid 字段赋值 值为rtestd  1000
#      添加一条新记录只给name、uid 字段赋值 值为rtest2d   2000
#
#                 my "insert into teadb.usertab(name,uid) values('rtestd',1000),
#                    ('rtest2d',2000);"
#
#   14 显示uid 是四位数的用户的用户名和uid值。
#
#    my "select name,uid from teadb.usertab where uid>=1000;" 
#  
#   15  把gid号最小的前5个用户信息保存到/mybak/min5.txt文件里。
#
#    sed -i '/\[mysqld]/a  secure_file_priv="/mybak" '  /etc/my.cnf
#    systemctl restart mysqld
#    mkdir /mybak
#    chown mysql  /mybak
#
#    my "select * from teadb.usertab order by uid limit 5  into outfile '/mybak/min5.txt'"
#   cat /mybak/min5.txt 
#
#   16 使用useradd 命令添加登录系统的用户 名为lucy 
#      把lucy用户的信息 添加到user1表里
#
#     my "create table teadb.user1(
#              name char(30)  not null,
#              password char(1) not null,
#              uid int(2)  not null,
#              gid int(2) not null,
#              comment char(150) not null,
#              homedir char(30),
#              shell char(30),
#              index(name) 
#              );"
#
#             useradd lucy 
#             tail -1 /etc/passwd > /mybak/a.txt
#             my "load data infile '/mybak/a.txt'
#                 into  table teadb.user1 
#                 fields  terminated by ':'
#                 lines terminated by '\n';"
#             my "desc teadb.user1;"
#             my "select * from teadb.user1;"
#
#    17  删除表中的 comment 字段
#    
#              my "alter table teadb.user1
#                  drop  comment;"
#
#    18  设置表中所有字段值不允许为空
#
#               my "alter table teadb.user1
#                   modify homedir char(30) not null; "
#  
#               my "alter table teadb.user1
#                   modify shell char(30) not null; "
#
#
#  
#               my "desc teadb.user1;"
# 
#    19  删除root 用户家目录字段的值
#
#               my "update teadb.usertab set homedir=null where name='root';"
#
#     20  显示 gid 大于500的用户的用户名 家目录和使用的shell
#
#              my "select name,homedir,shell  from teadb.usertab where gid>500;"
#
#     21  删除uid大于100的用户记录
#
#              my "delete from teadb.usertab where uid>100;"
#
#    22  显示uid号在10到30区间的用户有多少个。
#
#              my "select count(*)  from  teadb.usertab where uid between 10 and 30;"
#
#     23  显示uid号是100以内的用户使用shell的类型。
#
#              my "select shell from teadb.usertab where uid < 100;"
#
#     24  显示uid号最小的前10个用户的信息
#
#              my  "select * from teadb.usertab order by uid limit 10;"
#  
#     25  显示表中第10条到第15条记录
#
#              my "select * from teadb.usertab  limit 10,5;"
#
#     26  显示uid号小于50且名字里有字母a  用户的详细信息
#               
#              my "select * from teadb.usertab where uid < 50 and name regexp '[a]';"
#  
#     27  只显示用户 root   bin   daemon  3个用户的详细信息。
#
#              my "select * from teadb.usertab where name='root' or name='bin' or name='daemon';"
#
#     28  显示除root用户之外所有用户的详细信息。
#
#              my "select * from teadb.usertab where name!='root';"
#
#     29  统计username 字段有多少条记
#
#              my "select count(name) from teadb.usertab ;"   
#
#     30  显示名字里含字母c  用户的详细信息
#
#              my "select * from teadb.usertab where name regexp '[c]';"
#    
#     31  在sex字段下方添加名为pay的字段，用来存储工资，默认值    是5000.00
#
#               my "alter table teadb.usertab 
#                   add pay float(11,2) default 5000 after sex;"
#
#     32  把所有女孩的工资修改为10000
#
#               my "update teadb.usertab set pay=10000 where sex='girl'"
#
#     33  把root用户的工资修改为30000
#         给adm用户涨500元工资
#
#                my "update teadb.usertab set pay=30000 where name='root'"
#                my "update teadb.usertab set pay=pay+500 where name='adm'"
#
#     34  查看所有用户的名字和工资    
#
#                 my "select name,pay from  teadb.usertab;" 
#
#     35  查看工资字段的平均值
#
#                 my "select avg(pay) from teadb.usertab;"
#
#      36  查看工资字段值小于平均工资的用户 是谁。
#          查看女生里谁的uid号最小
#
#                 my "select name from teadb.usertab where pay<(select avg(pay) from teadb.usertab);"       
#                 my "select name,uid  from teadb.usertab where uid=(select min(uid) from teadb.usertab where sex='girl');"
#
#      38  查看bin用户的uid gid 字段的值 及 这2个字段相加的和 
# 
#                my "select uid,gid,sum(uid+gid) as haha  from teadb.usertab where name='bin' group by uid,gid;" 
#
#           MySQL大小写敏感说明
#          经常遇到的问题，一些不是特别重要但是又比较郁闷的事情。例如今天这个MySQL大小写敏感。
#          先上测试结果。
#          
#          Linux环境下，不是windows平台下。区别很大。注意。
#          一图胜千言
#           
#          mysql> show create table Ac;
#          +-------+-------------------------------------------------------------------------------------------------------------------------+
#          | Table | Create Table                                                                                                            |
#          +-------+-------------------------------------------------------------------------------------------------------------------------+
#          | Ac    | CREATE TABLE `Ac` (
#            `a` varchar(20) DEFAULT NULL,
#            `c` varchar(20) DEFAULT NULL
#          ) ENGINE=InnoDB DEFAULT CHARSET=utf8 |
#          +-------+-------------------------------------------------------------------------------------------------------------------------+
#          1 row in set (0.00 sec)
#           
#          mysql>
#          mysql> insert into Ac  values ('1q','1q');
#          Query OK, 1 row affected (0.00 sec)
#           
#          mysql> insert into Ac  values ('1Q','1Q');
#          Query OK, 1 row affected (0.00 sec)
#           
#          mysql> select * from Ac WHERE a='1q';
#          +------+------+
#          | a    | c    |
#          +------+------+
#          | 1q   | 1q   |
#          | 1Q   | 1Q   |
#          +------+------+
#          2 rows in set (0.00 sec)
#           
#          mysql> select * from AC ;
#          ERROR 1146 (42S02): Table 'test.AC' doesn't exist
#          mysql> select * from Ac  where A='1Q';
#          +------+------+
#          | a    | c    |
#          +------+------+
#          | 1q   | 1q   |
#          | 1Q   | 1Q   |
#          +------+------+
#          2 rows in set (0.00 sec)
#           
#          如上的结果能反应说明以下结论。
#           
#          MySQL在Linux下数据库名、表名、列名、别名大小写规则是这样的：
#          　　1、数据库名与表名是严格区分大小写的；
#          　　2、表的别名是严格区分大小写的；
#          　　3、列名与列的别名在所有的情况下均是忽略大小写的；
#                4、字段内容默认情况下是大小写不敏感的。
#           
#          mysql中控制数据库名和表名的大小写敏感由参数lower_case_table_names控制，为0时表示区分大小写，为1时，表示将名字转化为小写后存储，不区分大小写。
#          mysql> show variables like '%case%';
#          +------------------------+-------+
#          | Variable_name          | Value |
#          +------------------------+-------+
#          | lower_case_file_system | OFF   |
#          | lower_case_table_names | 0     |
#          +------------------------+-------+
#          2 rows in set (0.00 sec)
#           
#          修改cnf配置文件或者编译的时候，需要重启服务。
#           
#           
#           MySQL存储的字段是不区分大小写的。这个有点不可思议。尤其是在用户注册的业务时候，会出现笑话。所以还是严格限制大小写敏感比如好。
#           
#          如何避免字段内容区分大小写。就是要新增字段的校验规则。
#          可以看出默认情况下字段内容是不区分大小写的。大小写不敏感。
#           
#          mysql> create table aa (a varchar(20) BINARY  , c varchar(20)) ;
#          Query OK, 0 rows affected (0.10 sec)
#           
#          mysql> show create table aa;
#          +-------+-------------------------------------------------------------------------------------------------------------------------------------------------------------+
#          | Table | Create Table                                                                                                                                                |
#          +-------+-------------------------------------------------------------------------------------------------------------------------------------------------------------+
#          | aa    | CREATE TABLE `aa` (
#            `a` varchar(20) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
#            `c` varchar(20) DEFAULT NULL
#          ) ENGINE=InnoDB DEFAULT CHARSET=utf8 |
#          +-------+-------------------------------------------------------------------------------------------------------------------------------------------------------------+
#          1 row in set (0.00 sec)
#           
#          mysql> select * from aa;
#          +------+------+
#          | a    | c    |
#          +------+------+
#          | a    | C    |
#          | a    | C    |
#          | A    | c    |
#          +------+------+
#          3 rows in set (0.00 sec)
#           
#          mysql> select * from aa where a = 'a';
#          +------+------+
#          | a    | c    |
#          +------+------+
#          | a    | C    |
#          | a    | C    |
#          +------+------+
#          2 rows in set (0.00 sec)
#           
#          mysql> select * from aa where a = 'A';
#          +------+------+
#          | a    | c    |
#          +------+------+
#          | A    | c    |
#          +------+------+
