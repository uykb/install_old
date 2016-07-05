Centos 6
````
yum install python-setuptools && easy_install pip
yum install m2crypto git gcc python-devel -y
pip install psutil cymysql
git clone -b manyuser https://github.com/breakwa11/shadowsocks.git
cd shadowsocks
cp /root/shadowsocks/config.json /root/shadowsocks/user-config.json
wget --no-check-certificate http://ss.wxliu.com/serverinfo.py -O /root/serverinfo.py
#wget --no-check-certificate https://raw.githubusercontent.com/wxliuxh/shadowsocks_install/master/ss-panel/install.sh -O /root/shadowsocks/tests/libsodium/install.sh
#sh /root/shadowsocks/tests/libsodium/install.sh
````
如果要使用 salsa20 或 chacha20 或 chacha20-ietf 算法，请安装 libsodium :
https://github.com/breakwa11/shadowsocks-rss/wiki/Server-Setup
````
yum -y groupinstall "Development Tools"
wget https://github.com/jedisct1/libsodium/releases/download/1.0.10/libsodium-1.0.10.tar.gz
tar xf libsodium-1.0.10.tar.gz && cd libsodium-1.0.10
./configure && make -j2 && make install
echo /usr/local/lib > /etc/ld.so.conf.d/usr_local_lib.conf
ldconfig
````
#编辑 apiconfig.py
````
MYSQL_HOST = 'localhost' //前端mysql域名/IP
MYSQL_PORT = 3306 //mysql端口
MYSQL_USER = 'ss' //mysql用户名
MYSQL_PASS = 'ss' //mysql密码
MYSQL_DB = 'shadowsocks' //数据库名
````
#编辑 user-config.json
````
"method":"aes-256-cfb", //修改成您要的加密方式的名称
"protocol": "auth_sha1_compatible", //修改成您要的协议插件名称
"obfs": "tls1.0_session_auth_compatible", //修改成您要的混淆插件名称
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
