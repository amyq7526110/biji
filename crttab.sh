#!/bin/bash 

my(){
  
   echo   
   echo -e "\033[31m $1 \033[0m"
   echo 
  
   mysql -e "$1"
      
} 
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

#      1.2 视图优点
#              • 简单
#              – 用户不需关心视图中的数据如何查询获得
#              – 视图中的数据已经是过滤好的符合条件的结果集
#              • 安全
#              – 用户只能看到视图中的数据
#              • 数据独立
#              – 一旦视图结构确定,可以屏蔽表结构对用户的影响

#             视图使用限制

#             • 不能在视图上创建索引
#             • 在视图的FROM子句中不能使用子查询
#             • 以下情形中的视图是不可更新的
#             – 包含以下关键字的SQL语句:聚合函数(SUM、MIN、
#               MAX、COUNT等)、DISTINCT、GROUP BY、
#               HAVING、UNION或UNION ALL
#             – 常量视图、JOIN、FROM一个不能更新的视图
#             – WHERE子句的子查询引用了FROM子句中的表
#             – 使用了临时表



#      1.3  视图的基本使用
#      创建视图
#
#       my "create view db9.v1 as select name,uid,shell from db9.user;"
#
#       my "select * from  db9.v1;"
 
#       my "desc db9.v1;"
   
#       my "grant select on db9.v1 to yaya@'%'   identified by 'Azsd1234.';"

#       my "create view db9.v2(vname,vuid) as select  name,uid from db9.user;"
 
#       my "select * from db9.v2;desc db9.v2;"   
   
#
#      查看视图

        
#        my "use db9;show tables;"


#        my "use db9;show table  status\G;"

#        my "use db9;show table status where comment='view'\G;"


#        my "use mysql ;show table status where comment='view'\G;"


#        my "show create view db9.v2;"



#      使用视图(update insert )
 
v1=db9.v1
user=db9.user
v2=db9.v2

#     my "update db9.v1 set name='admin' where name='root';"

#     my "select name from db9.user;"
 
#     my "select name from db9.v1;"

#     my "delete from $user where name='lucy';"

#     my "insert into $user(name,uid) values('lucy',888);"

#     my "select name,uid from $user where name='lucy';"
  
#     my "select name,uid from $v1 where name='lucy';"

      

#      删除视图
 
#      my "drop view db9.v2;"
#      my "drop view db9.user;"
#      my "drop view db9.v1;"
#      my "use db9; show tables;"
 
#      1.4  AS定义视图中字段名称
#      1.5 OR REPLACEX选项的使用

#      视图进阶



#      创建视图的完全格式
t1=db9.t1
t2=db9.t2
a=db9.a
b=db9.b

#        my "create table db9.t1 select name,uid from $user  limit 3 ;"

#        my "create table db9.t2 select name,uid from $user  limit 6 ;"

#        my "select * from  $t1,$t2  where $t1.name=$t2.name;"
          
#        my "create view $v1 as select  * from $t1,$t2 where $t1.name=$t2.name;"
 
#        my "select a.name as  aname , b.name as bname   from $t1 a , $t2 b where a.name=b.name;"
v3=db9.v3
v4=db9.v4

#        my "create view $v3 as select a.name as  aname , b.name as bname   from $t1 a , $t2 b where a.name=b.name;"
    
#        my "select * from $v1;"

#        my "select t1.name,t2.name from $t1  left join $t2 on $t1.name=$t2.name; "

#        my "create view db9.v4(aname,bname) as select t1.name,t2.name from $t1  left join $t2 on $t1.name=$t2.name; "

#        my "select * from db9.v4;"

#          my "create or replace view  $v4  as select * from $user;"

#          my "select * from $v4;"











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
    user2=db9.user2
#       my "create table $user2 select * from $user where uid>=10 and uid<=1000;"
#       my "select * from $user2;" 

    v5=db9.v5

#       my "create view $v5 as select name,uid from $user2;"
 
#          my "select * from $v5 where uid=11;"
 
#        my "update $v5 set uid=1111 where name='operator';"

#     mysql -e "select * from db9.user2;"

 v6=db9.v6
#       my "create view $v6 as select *  from $user2  where uid <=100 with local check option;use db9 ; show tables;"
  
#       my  "select name,uid from db9.v6;"

#       my "update $v6 set uid=101 where name='ftp';"
#       my "update $v6 set uid=77 where name='ftp';"

#       my  "select name,uid from db9.v6;"



v7=db9.v7
v8=db9.v8

#        my "create view $v7 as select name,uid,shell from $user2 where uid>=10 and uid<=50;"
 

#        my "create view $v8 as select name,uid,shell from $v7  where uid>=20 with cascaded check option;select * from $v8; "
  
#         my "select * from $v7;"
#         my "select * from $v8;"
#   
#         my "update $v8 set uid=16 where name='ntp';"
#         
#         my "update $v8 set uid=51 where name='ntp';"

 
#      mysql> create view v1 as
#      select * from a where uid < 10 with check option;
#      Query OK, 0 rows affected (0.09 sec)
#      mysql> create view v2 as
#      select * from v1 where uid >=5 with local check option;
#      Query OK, 0 rows affected (0.09 sec)


#      
#      二、mysql存储过程

#          存储过程介绍

#          • 存储过程,相当于是MySQL语句组成的脚本
#          – 指的是数据库中保存的一系列SQL命令的集合
#          – 可以在存储过程中使用变量、条件判断、流程控制等

#          存储过程优点

#          • 提高性能
#          • 可减轻网络负担
#          • 可以防止对表的直接访问
#          • 避免重复编写SQL操作


#      2.1 基本使用：创建  查看  调用   删除 

#        创建存储过程

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

p1=db9.p1 
#              my "delimiter //
#                  create procedure db9.p1()
#                  begin
#                  select * from $user limit 10;
#                  end
#                  //
#                  delimiter ;"
#              my "call $p1();"       

#               my "delimiter //
#                   create procedure $p1()
#                   begin
#                   select count(*) from $user  where shell='/bin/bash';
#                   end
#                   //
#                   delimiter ;
#                   my "call $p1();"
              

c1=db9.c1

#               my "delimiter //
#                   create procedure $c1()
#                   begin 
#                   select user();
#                   end
#                   //
#                   delimiter ;"
#                   my "call $c1"


#             查看存储过程

#             • 方法1

#             – mysql> show procedure status;

#             • 方法2

#             – mysql> select db,name,type from mysql.proc

#             where name="存储过程名";

#             mysql> select db,name,type from mysql.proc where name="say";

#             +---------+------+-------------+
#             | db
#             | name | type
#             |
#             +---------+------+-------------+
#             | studydb | say | PROCEDURE |
#             +---------+------+-------------+

#               my "desc mysql.proc\G;"
#
#               my "select db,name,type from mysql.proc where name='p1';"
#
#               my "select db,name,type from mysql.proc where type='procedure';"
#
#               my "select * from mysql.proc where name='p1'\G;"
#
#               my "select body from mysql.proc where name='p1';"


#              调用/删除存储过程

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
    
#               my "drop procedure $p1;"
   
#               my "call $p1();"

#      2.2 存储过程参数类型： in   out   inout

         
 

#             参数类型
#             • 调用参数时,名称前也不需要加@
#             – create procedure 名称(  类型 参数名 数据类型 , 类型 参数名 数据类型 )


#             关键字

#             in    输入参数 作用是给存储过程传值,必须在调用存储过程时赋值,在存储过程中该参数的值不允许修改;默认类型是in
p5=db9.p5

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

#             out   输出参数 该值可在存储过程内部被改变,并可返回。

p6=db9.p6
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
                 


#             inout 输入/输出参数

#             in

#             调用时指定,并且可被改变和返回参数类型(续1)

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
#      2.3mysql 变量类型： 会话变量 全局变量   用户变量   局部变量

#              变量类型

#                  • 调用局部变量时,变量名前不需要加@
#        名称

#        会话变量
#        会话变量和全局变量叫系统变量 使用set命令定义;
        
    
#          my "show session variables like '%time%';" 

 #         my "set session sort_buffer_size=888888;show session variables like 'sort_buffer_size';"
  
  #        my  "show  variables like 'sort_buffer_size';"

#        全局变量
  
#          my "show global variables;"

#        全局变量的修改会影响到整个服务器,但是对会话
#        变量的修改,只会影响到当前的会话。

#           my " select @@hostname;"



#        用户变量
#             在客户端连接到数据库服务的整个过程中都是有效
#             的。当前连接断开后所有用户变量失效。
#           定义 set
#           @变量名=值;
#           输出 select @变量名;a

   #               my "select max(uid) into @y from $user; select @y;"

    #              my "set @x=55; select @x;"
                    

#        局部变量 

#           存储过程中的begin/end。其有效范围仅限于该语
#           句块中,语句块执行完毕后,变量失效。
#           declare专门用来定义局部变量。
             p3=db9.p3
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

#             my "set @x=2;set @j=5 ;set @k=@x * @j;select @k;" 
#
#             my "set @z=1+2;select @z;"
#
#             my "set @x=1 ; set @y=2;set  @z=@x/@y;select @z;"
#             my "set @x=2 ; set @y=5;set  @z=@x div @y;select @z;"
#             my "set @x=9 ; set @y=4;set  @z=@x % @y;select @z;"
p4=db9.p4     
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
#      2.5 条件判断符号：
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
#                                  mysqldump  
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
#          知
#          识
#          讲
#          解
#          含 义
#          key_buffer-size 用于MyISAM引擎的关键索引缓存大小
#          sort_buffer_size 为每个要排序的线程分配此大小的缓存空间
#          read_buffer_size 为顺序读取表记录保留的缓存大小
#          thread_cache_size 允许保存在缓存中被重用的线程数量
#           table_open_cache 为所有线程缓存的打开的表的数量
#
#     my "show variables like '%buffer%';"
# 
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
#
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
#3.2  安装第3方软件提供备份命令，对数据做增量备份
#软件介绍 Percona 开源软件  在线热备不锁表  适用于生成环境。
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
#   -----------------------------------------------------------
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
#          1 row in set (0.00 sec)
#           
#          原因如下:
#          字段值的大小写由mysql的校对规则来控制。提到校对规则，就不得不说字符集。字符集是一套符号和编码，校对规则是在字符集内用于比较字符的一套规则  .
#          一般而言，校对规则以其相关的字符集名开始，通常包括一个语言名，并且以_ci（大小写不敏感）、_cs（大小写敏感）或_bin（二元）结束 。比如 utf8字符集，utf8_general_ci,表示不区分大小写，这个是utf8字符集默认的校对规则；utf8_general_cs表示区分大小写，utf8_bin表示二进制比较，同样也区分大小写 。
#
#
#
#
#
#
#
#
#
