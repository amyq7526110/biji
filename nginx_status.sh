#!/bin/bash

listen=LISTEN
sre=SYN-RECV
sse=SYN-SENT
est=ESTAB
close=CLOSE-WAIT
tiwa=TIME-WAIT
fw1=FIN-WAIT-1
fw2=FIN-WAIT-2

x=`ss -ntpa  |  grep :80 | awk '{ip[$1]++}END{for (i in ip){print ip[i],i}}'`

if   [ $#   -eq   0   ];then
exit  
elif ! echo $x  | grep -q $1 ;then
echo 0
exit
fi 
case $1 in  
LISTEN)
echo $x | sed  -r 's/(.*) (.*) '$listen'(.*)/\2/'
;;
SYN-RECV)
echo $x | sed  -r 's/(.*) (.*) '$ser'(.*)/\2/'
;;
SYN-SENT)
echo $x | sed  -r 's/(.*) (.*) '$sse'(.*)/\2/'
;;
ESTAB)
echo $x | sed  -r 's/(.*) (.*) '$est'(.*)/\2/'
;;
CLOSE)
echo $x | sed  -r 's/(.*) (.*) '$close'(.*)/\2/'
;;
TIME-WAIT)
echo $x | sed  -r 's/(.*) (.*) '$tiwa'(.*)/\2/'
;;
FIN-WAIT-1)
echo $x | sed  -r 's/(.*) (.*) '$fw1'(.*)/\2/'
;;
FIN-WAIT-2)
echo $x | sed  -r 's/(.*) (.*) '$fw2'(.*)/\2/'
;;
esac
