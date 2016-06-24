#! /bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
#===============================================================================================
#   System Required:  CentOS6.x (32bit/64bit)
#   Description: Install Shadowsocks-libev server for CentOS 6 or 7
#   Author: Teddysun <i@teddysun.com>
#   Thanks: @m0d8ye <https://twitter.com/m0d8ye>
#   Intro:  https://teddysun.com/357.html
#===============================================================================================

clear
echo "#############################################################"
echo "#     添加/删除-端口/密码        默认加密 aes-256-cfb       #"
echo "#############################################################"
echo ""

# Make sure only root can run our script
function rootness(){
if [[ $EUID -ne 0 ]]; then
   echo "Error:This script must be run as root!" 1>&2
   exit 1
fi
}

# Get version
function getversion(){
    if [[ -s /etc/redhat-release ]];then
        grep -oE  "[0-9.]+" /etc/redhat-release
    else    
        grep -oE  "[0-9.]+" /etc/issue
    fi    
}

# CentOS version
function centosversion(){
    local code=$1
    local version="`getversion`"
    local main_ver=${version%%.*}
    if [ $main_ver == $code ];then
        return 0
    else
        return 1
    fi        
}

# Disable selinux
function disable_selinux(){
if [ -s /etc/selinux/config ] && grep 'SELINUX=enforcing' /etc/selinux/config; then
    sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
    setenforce 0
fi
}

# Pre-installation settings
function pre_install(){
    # Not support CentOS 5
    if centosversion 5; then
        echo "Not support CentOS 5, please change to CentOS 6 or 7 and try again."
        exit 1
    fi
    #Set shadowsocks-libev config password
    echo "请输入密码 for shadowsocks-libev:"
    read -p "(默认密码: wxliuxh):" shadowsockspwd
    [ -z "$shadowsockspwd" ] && shadowsockspwd="wxliuxh"
    echo ""
    echo "---------------------------"
    echo "密码 = $shadowsockspwd"
    echo "---------------------------"
    echo ""
    #Set shadowsocks-libev config port
    while true
    do
    echo -e "请输入端口 for shadowsocks-libev [1-65535]:"
    read -p "(默认端口: 16888):" shadowsocksport
    [ -z "$shadowsocksport" ] && shadowsocksport="16888"
    expr $shadowsocksport + 0 &>/dev/null
    if [ $? -eq 0 ]; then
        if [ $shadowsocksport -ge 1 ] && [ $shadowsocksport -le 65535 ]; then
            echo ""
            echo "---------------------------"
            echo "端口 = $shadowsocksport"
            echo "---------------------------"
            echo ""
            break
        else
            echo "Input error! Please input correct numbers."
        fi
    else
        echo "Input error! Please input correct numbers."
    fi
    done
    get_char(){
        SAVEDSTTY=`stty -g`
        stty -echo
        stty cbreak
        dd if=/dev/tty bs=1 count=1 2> /dev/null
        stty -raw
        stty echo
        stty $SAVEDSTTY
    }
    echo ""
    echo "按任意键继续安装...或 按 Ctrl+C 取消安装"
    char=`get_char`
    # Get IP address
    echo "Getting Public IP address, Please wait a moment..."
    IP=$(curl -s -4 icanhazip.com)
    if [[ "$IP" = "" ]]; then
        IP=`curl -s -4 ipinfo.io/ip`
    fi
    echo -e "Your main public IP is\t\033[32m$IP\033[0m"
    echo ""
    #Current folder
    cur_dir=`pwd`
    cd $cur_dir
}

# Config shadowsocks
function config_shadowsocks(){
    if [ ! -d /root/supervisor ];then
        mkdir /root/supervisor
		mkdir /root/supervisor/log
    fi
    cat > /root/supervisor/ss-${shadowsocksport}.conf<<-EOF
[program:sslibev_${shadowsocksport}]
command=/usr/local/bin/ss-server -u -p ${shadowsocksport} -k ${shadowsockspwd} -m aes-256-cfb
autostart=true
autorestart=true
user=root
startsecs=10
startretries=36
EOF
}

function firewall_set(){
    echo "开始防火墙设置..."
    if centosversion 6; then
        /etc/init.d/iptables status > /dev/null 2>&1
        if [ $? -eq 0 ]; then
            iptables -L -n | grep '${shadowsocksport}' | grep 'ACCEPT' > /dev/null 2>&1
            if [ $? -ne 0 ]; then
                iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport ${shadowsocksport} -j ACCEPT
                iptables -I INPUT -m state --state NEW -m udp -p udp --dport ${shadowsocksport} -j ACCEPT
                /etc/init.d/iptables save
                /etc/init.d/iptables restart
            else
                echo "端口 ${shadowsocksport} 成功添加防火墙策略."
            fi
        else
            echo "警告：iptables好像未运行或未安装，如有需要请手动设置."
        fi
    elif centosversion 7; then
        systemctl status firewalld > /dev/null 2>&1
        if [ $? -eq 0 ];then
            firewall-cmd --permanent --zone=public --add-port=${shadowsocksport}/tcp
            firewall-cmd --permanent --zone=public --add-port=${shadowsocksport}/udp
            firewall-cmd --reload
        else
            echo "防火墙貌似没有运行，尝试启动..."
            systemctl start firewalld
            if [ $? -eq 0 ];then
                firewall-cmd --permanent --zone=public --add-port=${shadowsocksport}/tcp
                firewall-cmd --permanent --zone=public --add-port=${shadowsocksport}/udp
                firewall-cmd --reload
            else
                echo "警告：尝试启动防火墙失败。如有需要请手动设置 ."
            fi
        fi
    fi
    echo "防火墙设置完成..."
}

# Install 
function install(){
    service supervisord restart
    clear
    echo ""
    echo "端口添加成功!"
    echo -e "服务器IP: \033[41;37m ${IP} \033[0m"
    echo -e "远程端口: \033[41;37m ${shadowsocksport} \033[0m"
    echo -e "你的密码: \033[41;37m ${shadowsockspwd} \033[0m"
    #echo -e "本地IP: \033[41;37m 127.0.0.1 \033[0m"
    echo -e "本地端口: \033[41;37m 1080 \033[0m"
    echo -e "加密方法: \033[41;37m aes-256-cfb \033[0m"
    echo ""
    echo "好好享受吧!"
    echo ""
    exit 0
}

# Uninstall Shadowsocks-libev
function uninstall_shadowsocks_libev(){
	cd /root/supervisor
	echo "---------------------------"
	ls
	echo "---------------------------"
	 while true
    do
    echo -e "请输入端口 for shadowsocks-libev [1-65535]:"
    read -p "(默认端口: 16888):" shadowsocksport
    [ -z "$shadowsocksport" ] && shadowsocksport="16888"
    expr $shadowsocksport + 0 &>/dev/null
    if [ $? -eq 0 ]; then
        if [ $shadowsocksport -ge 1 ] && [ $shadowsocksport -le 65535 ]; then
            echo ""
            echo "---------------------------"
            echo "端口 = $shadowsocksport"
            echo "---------------------------"
            echo ""
            break
        else
            echo "输入错误！请输入正确的数字."
        fi
    else
        echo "输入错误！请输入正确的数字."
    fi
    done
	cd /root
	rm -rf /root/supervisor/ss-${shadowsocksport}.conf
	service supervisord restart
	echo "端口配置删除成功!"
	iptables -D INPUT -m state --state NEW -m tcp -p tcp --dport ${shadowsocksport} -j ACCEPT
        iptables -D INPUT -m state --state NEW -m udp -p udp --dport ${shadowsocksport} -j ACCEPT
        /etc/init.d/iptables save
        /etc/init.d/iptables restart
        echo "防火墙策略删除成功!"
}

# Install Shadowsocks-libev
function install_shadowsocks_libev(){
    rootness
    disable_selinux
    pre_install
    config_shadowsocks
    firewall_set
    install
}

# Initialization step
action=$1
[ -z $1 ] && action=add
case "$action" in
add)
    install_shadowsocks_libev
    ;;
del)
    uninstall_shadowsocks_libev
    ;;
*)
    echo "参数错误! [${action} ]"
	echo "安装命令: ./`basename $0`"
	echo "或"
    echo "卸载命令: ./`basename $0` {add|del}"
    ;;
esac
