#Linux下禁止ping

##首先登陆服务器终端之间执行:
````
echo 1 > /proc/sys/net/ipv4/icmp_echo_ignore_all
````
##这样就可以禁ping了。如果想恢复ping可以执行命令
````
echo 0 > /proc/sys/net/ipv4/icmp_echo_ignore_all
````
##kaiji开机zid开机自动jinzhi开机自动禁止PING
````
echo '/usr/bin/kms-server' >> /etc/rc.local
````
