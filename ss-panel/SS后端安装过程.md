#Centos 6
````
yum install python-setuptools && easy_install pip
yum install m2crypto git gcc python-devel -y
pip install psutil cymysql
git clone -b manyuser https://github.com/mengskysama/shadowsocks.git
cd shadowsocks/shadowsocks
wget --no-check-certificate http://ss.wxliu.com/serverinfo.py -O /root/serverinfo.py
````
###不支持 salsa20 或 chacha20 或 chacha20-ietf 等新算法，请安装 SSR

###编辑 Config.py
````
MYSQL_HOST = 'localhost' //前端mysql域名/IP
MYSQL_PORT = 3306 //mysql端口
MYSQL_USER = 'ss' //mysql用户名
MYSQL_PASS = 'ss' //mysql密码
MYSQL_DB = 'ss-panel' //数据库名
````
###编辑 serverinfo.py
````
修改serverinfo.py中posturl为你的站点地址，server_id为当前节点对应的ID（/admin/node.php第一列）
````
###测试脚本运行命令
````
python serverinfo.py //本脚本可独立于Shadowsocks服务端运行/The script can be used independently of Shadowsocks server.
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
cd /root/shadowsocks/shadowsocks
python server.py
````
更新源代码
````
cd shadowsocks
git pull
````
