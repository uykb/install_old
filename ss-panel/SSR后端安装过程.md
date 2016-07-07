#Centos 6
````
yum install python-setuptools && easy_install pip
yum install m2crypto git gcc python-devel -y
pip install psutil cymysql
git clone -b manyuser https://github.com/breakwa11/shadowsocks.git
cd shadowsocks
cp /root/shadowsocks/config.json /root/shadowsocks/user-config.json
#wget --no-check-certificate http://ss.wxliu.com/serverinfo.py -O /root/serverinfo.py
wget --no-check-certificate https://ss.wxliu.com/serverinfo.py -O /root/serverinfo.py
````
###如果要使用 salsa20 或 chacha20 或 chacha20-ietf 算法，请安装 libsodium :
https://github.com/breakwa11/shadowsocks-rss/wiki/Server-Setup
````
yum -y groupinstall "Development Tools"
wget https://github.com/jedisct1/libsodium/releases/download/1.0.10/libsodium-1.0.10.tar.gz
tar xf libsodium-1.0.10.tar.gz && cd libsodium-1.0.10
./configure && make -j2 && make install
echo /usr/local/lib > /etc/ld.so.conf.d/usr_local_lib.conf
ldconfig
````
###编辑 serverinfo.py
````
修改serverinfo.py中posturl为你的站点地址，server_id为当前节点对应的ID（/admin/node.php第一列）
````
###测试脚本运行命令
````
python serverinfo.py //本脚本可独立于Shadowsocks服务端运行/The script can be used independently of Shadowsocks server.
````
###编辑 apiconfig.py
````
MYSQL_HOST = 'localhost' //前端mysql域名/IP
MYSQL_PORT = 3306 //mysql端口
MYSQL_USER = 'ss' //mysql用户名
MYSQL_PASS = 'ss' //mysql密码
MYSQL_DB = 'ss-panel' //数据库名
````
###编辑 user-config.json
````
"method":"aes-256-cfb", //修改成您要的加密方式的名称
"protocol": "auth_sha1_compatible", //修改成您要的协议插件名称
"obfs": "tls1.0_session_auth_compatible", //修改成您要的混淆插件名称
````
````
{
    "server": "0.0.0.0",
    "server_ipv6": "::",
    "server_port": 8388,
    "local_address": "127.0.0.1",
    "local_port": 1080,
    "password": "m",
    "timeout": 120,
    "udp_timeout": 60,
    "method": "chacha20",
    "protocol": "origin",
    "protocol_param": "",
    "obfs": "plain",
    "obfs_param": "",
    "dns_ipv6": false,
    "connect_verbose_info": 0,
    "redirect": "",
    "fast_open": false
}

````
###安装守护进程 supervisord
````
easy_install supervisor
````
````
wget --no-check-certificate https://raw.githubusercontent.com/wxliuxh/shadowsocks_install/master/ss-panel/supervisord.conf -O /etc/supervisord.conf
wget --no-check-certificate https://raw.githubusercontent.com/wxliuxh/supervisord/master/supervisord -O /etc/init.d/supervisord
wget --no-check-certificate https://raw.githubusercontent.com/wxliuxh/shadowsocks_install/master/limits.conf -O /etc/security/limits.conf
````
````
chmod 755 /etc/init.d/supervisord
chkconfig supervisord on
service supervisord start
````




服务端运行与停止
````
cd shadowsocks
python server.py
````
更新源代码
````
cd shadowsocks
git pull
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
