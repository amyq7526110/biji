#!/bin/bash
mytomcat(){
ln=lnmp_soft.tar.gz
tc=apache-tomcat-8.0.30.tar.gz
[ ! -f $ln ]&& echo "没有lnmp_soft.tar.gz" && exit
tar -xf $ln
cd  lnmp_soft/
[ ! -f $tc ]&& echo "没有apache-tomcat-8.0.30.tar.gz" && exit
tar -xf $tc
mv  apache-tomcat-8.0.30/  /usr/local/tomcat
useradd  -s /sbin/tomcat  tomcat
chown -R tomcat:tomcat /usr/local/tomcat/
echo "#!/bin/bash
case \$1 in
-s)
su  - tomcat  -s /bin/bash -c '/usr/local/tomcat/bin/shutdown.sh'  &> /dev/null
;;
-r)
su - tomcat -c '/usr/local/tomcat/bin/shutdown.sh'  -s /bin/bash  &> /dev/null
su - tomcat -c '/usr/local/tomcat/bin/startup.sh'  -s /bin/bash  &> /dev/null
;;
-e)
echo "/bin/tomcat"  >> /etc/rc.local
chmod +x /etc/rc.local
;;
-de)
if grep -q "/bin/tomcat" /etc/ec.local ;then
sed  -i  's#/bin/tomcat##' /etc/rc.local
else
echo "没有自起"
fi
;;
*)
su - tomcat -c '/usr/local/tomcat/bin/startup.sh'  -s /bin/bash  &> /dev/null
;;
esac"  > tomcat
chmod +x tomcat
cp tomcat  /bin/tomcat
cd /usr/local/tomcat/lib
yum -y install java-1.8.0-openjdk-devel.x86_64
jar -xf catalina.jar
sed -ri 's/.info(.*)/.info=nginx\/1.9.2/'  org/apache/catalina/util/ServerInfo.properties
sed -ri 's/.number(.*)/.number=1.9.2/'  org/apache/catalina/util/ServerInfo.properties
/bin/tomcat
}
mytomcat
