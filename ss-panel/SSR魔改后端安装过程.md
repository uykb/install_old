#Centos 6
````
yum -y install python-setuptools && easy_install pip
yum -y install git wget
pip install cymysql speedtest-cli
#easy_install speedtest-cli
#pip install git+https://github.com/sivel/speedtest-cli.git
git clone -b manyuser https://github.com/glzjin/shadowsocks.git
cd shadowsocks
cp apiconfig.py userapiconfig.py
cp config.json user-config.json
````
###如果要使用 salsa20 或 chacha20 或 chacha20-ietf 算法，请安装 libsodium :
https://github.com/breakwa11/shadowsocks-rss/wiki/Server-Setup
````
yum -y groupinstall "Development Tools"
cd /root
wget https://github.com/jedisct1/libsodium/releases/download/1.0.11/libsodium-1.0.11.tar.gz
tar xf libsodium-1.0.11.tar.gz && cd libsodium-1.0.11
./configure && make -j2 && make install
echo /usr/local/lib > /etc/ld.so.conf.d/usr_local_lib.conf
ldconfig
rm -rf /root/libsodium-1.0.11.tar.gz
cd /root
````
###然后主要编辑 userapiconfig.py ,来解释下里面各项配置的意思
````
# Config

#节点ID
NODE_ID = 1

#自动化测速，为0不测试，此处以小时为单位，要和 ss-panel 设置的小时数一致
SPEEDTEST = 6

#云安全，自动上报与下载封禁IP，1为开启，0为关闭
CLOUDSAFE = 1

#自动封禁SS密码和加密方式错误的 IP，1为开启，0为关闭
ANTISSATTACK = 0

#是否接受上级下发的命令，如果你要用这个命令，请参考我之前写的东西，公钥放在目录下的 ssshell.asc
AUTOEXEC = 1

是否以多线程模式运行，关闭这个限速就会无效。请优先测试 1 ，开启试试，能运行没。
MULTI_THREAD = 0

#不明觉厉
SERVER_PUB_ADDR = '127.0.0.1' # mujson_mgr need this to generate ssr link

#此处不要修改
API_INTERFACE = 'glzjinmod' #mudbjson, sspanelv2, sspanelv3, sspanelv3ssr, muapiv2(not support)

#mudb，不要管
MUDB_FILE = 'mudb.json'

# Mysql 数据库连接信息
MYSQL_HOST = '127.0.0.1'
MYSQL_PORT = 3306
MYSQL_USER = 'ss'
MYSQL_PASS = 'ss'
MYSQL_DB = 'shadowsocks'
MYSQL_UPDATE_TIME = 60

# 是否启用SSL连接，0为关，1为开
MYSQL_SSL_ENABLE = 0

# 客户端证书目录，请看 https://github.com/glzjin/shadowsocks/wiki/Mysql-SSL%E9%85%8D%E7%BD%AE

MYSQL_SSL_CERT = '/root/shadowsocks/client-cert.pem'
MYSQL_SSL_KEY = '/root/shadowsocks/client-key.pem'
MYSQL_SSL_CA = '/root/shadowsocks/ca.pem'

# API，不用管
API_HOST = '127.0.0.1'
API_PORT = 80
API_PATH = '/mu/v2/'
API_TOKEN = 'abcdef'
API_UPDATE_TIME = 60

# Manager 不用管
MANAGE_PASS = 'ss233333333'
#if you want manage in other server you should set this value to global ip
MANAGE_BIND_IP = '127.0.0.1'
#make sure this port is idle
MANAGE_PORT = 23333
````
###特殊节点需要替换文件-我自用的.你们看懂了再用
````
rm -rf /root/shadowsocks/*.pyc
wget --no-check-certificate https://raw.githubusercontent.com/wxliuxh/shadowsocks_install/master/ss-panel/switchrulev3.py -O /root/shadowsocks/switchrule.py
````
###安装守护进程 supervisord
````
easy_install supervisor
````
````
wget --no-check-certificate https://raw.githubusercontent.com/wxliuxh/shadowsocks_install/master/ss-panel/supervisordv3.conf -O /etc/supervisord.conf
wget --no-check-certificate https://raw.githubusercontent.com/wxliuxh/supervisord/master/supervisord -O /etc/init.d/supervisord
wget --no-check-certificate https://raw.githubusercontent.com/wxliuxh/shadowsocks_install/master/limits.conf -O /etc/security/limits.conf
````
````
chmod 755 /etc/init.d/supervisord
chkconfig supervisord on
service supervisord start
````
### 测速
````
speedtest-cli
````
### 关闭关闭开启防火墙 关闭开启防火墙防火墙
````
chkconfig iptables off
service iptables stop

1) 重启后生效 
开启： chkconfig iptables on 
关闭： chkconfig iptables off 

2) 即时生效，重启后失效 
开启： service iptables start 
关闭： service iptables stop 
````
###出现(1042, u"Can't get hostname for your address")错误
````
my.cnf里,[mysqld]项目下
添加
skip-name-resolve
#忽略主机名的方式访问
````

###服务端运行与停止
````
service supervisord stop
service supervisord restart
----
cd /root/shadowsocks
python server.py &
killall python server.py
````
###关于升级
````
cd shadowsocks
git pull
````
###记得看 https://github.com/glzjin/shadowsocks/wiki/重大更新日志 添加配置项。
###报错?
````
pip install ordereddict
pip install gnupg
````

id //用户id数据库字段说明:
````
email //用户邮箱
pass //用户密码
passwd //ss密码
t //最后使用的时间
u //已上传流量
d //已下载流量
transfer_enable //可用流量（总量）
port //ss端口
switch //保留字段
enable //启用或禁用ss帐号（1启用，0禁用）
type //保留字段
last_get_gift_time //保留字段
last_rest_pass_time //保留字段
````
