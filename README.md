# shadowsocks_install
原地址:https://github.com/teddysun/shadowsocks_install

#本脚本选用libev 和 supervisord 做成的一键安装脚本

libev本身不支持多用户配置,研究发现supervisord可以通过独立的配置文件来多开SS.这样就成了多用户模式了.<br>
由于添加麻烦,又做成了一键设置脚本-脚本会根据你的端口添加/删除防火墙策略<br>
系统改为centos 6 我用的是i386<br>
提醒:下面这是一整行代码.请完整复制.这是安装脚本,同时也是更新安装最新版本的shadowsocks-libev脚本

```Bash
cd /root && rm -rf shadowsocks-libev.sh && wget --no-check-certificate https://raw.githubusercontent.com/wxliuxh/shadowsocks_install/master/shadowsocks-libev.sh && sh ./shadowsocks-libev.sh && rm -rf shadowsocks-libev.sh
```
安装完成后再运行以下代码配置端口和密码
```
./add20.sh
```
删除已配置端口
```
./add20.sh del
```
卸载shadowsocks-libev,请注意,卸载不会丢失端口配置.如需删除请手动删除/root/supervisor文件夹即可
```Bash
cd /root && rm -rf shadowsocks-libev.sh && wget --no-check-certificate https://raw.githubusercontent.com/wxliuxh/shadowsocks_install/master/shadowsocks-libev.sh && sh ./shadowsocks-libev.sh uninstall && rm -rf shadowsocks-libev.sh
```

更新操作端口的sh脚本
```Bash
cd /root && rm -rf shadowsocks-libev.sh && wget --no-check-certificate https://raw.githubusercontent.com/wxliuxh/shadowsocks_install/master/shadowsocks-libev.sh && sh ./shadowsocks-libev.sh upscript && rm -rf shadowsocks-libev.sh
```

#以下为注释
脚本会自动同步时间为北京时间,安装shadowsocks-libev和supervisord,并且下载2个一键配置脚本,脚本的区别是加密不一样

安装完成后,运行 ./add20.sh 或者 ./add256.sh 进行端口配置.<br>删除的话 ./add20.sh del 或者 ./add256.sh del 均可.<br>提示:删除这2个脚本是通用的<br>
配置完成后立即起效<br>
支持UDP转发 timeout默认为60
