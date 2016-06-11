# shadowsocks_install
原地址:https://github.com/teddysun/shadowsocks_install

不知道什么原因.用go版和py版经常自杀..所以选用libev 和 supervisord 做成一键安装脚本

libev不支持多用户配置,研究发现supervisord可以通过独立的配置文件来多开SS.这样就成了多用户模式了.

由于添加麻烦,又做成了一键设置脚本

系统改为centos 6  我用的是x86
--------------------------------------
cd /root

rm -rf shadowsocks-libev.sh

wget --no-check-certificate https://raw.githubusercontent.com/wxliuxh/shadowsocks_install/master/shadowsocks-libev.sh

chmod +x shadowsocks-libev.sh

./shadowsocks-libev.sh
---------------------------------------

脚本会自动同步时间为北京时间,安装shadowsocks-libev和supervisord,并且下载2个一键配置脚本,脚本的区别是加密不一样

安装完成后,运行 ./add20.sh 或者 ./add256.sh 进行端口配置.删除的话 ./add20.sh del 或者 ./add256.sh del

配置完成后立即起效

支持UDP转发
