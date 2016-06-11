#! /bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
#===============================================================================================
#   System Required:  Debian or Ubuntu (32bit/64bit)
#   Description: Install Shadowsocks-libev server for Debian or Ubuntu
#   Author: Teddysun <i@teddysun.com>
#   Thanks: @m0d8ye <https://twitter.com/m0d8ye>
#   Intro:  https://teddysun.com/358.html
#===============================================================================================

clear
echo
echo "#############################################################"
echo "# 安装 Shadowsocks-libev 服务 for Debian or Ubuntu          #"
echo "# 添加端口或覆盖密码                                        #"
echo "# 制作: wxliuxh                                             #"
echo "#############################################################"
echo

# Make sure only root can run our script
function rootness(){
if [[ $EUID -ne 0 ]]; then
    echo "Error:This script must be run as root!" 1>&2
    exit 1
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
    #Set shadowsocks-libev config password
    echo "请输入要设置的密码 for shadowsocks-libev:"
    read -p "(默认密码: wxliu):" shadowsockspwd
    [ -z "$shadowsockspwd" ] && shadowsockspwd="wxliu"
    echo
    echo "---------------------------"
    echo "密码 = $shadowsockspwd"
    echo "---------------------------"
    echo
    #Set shadowsocks-libev config port
    while true
    do
    echo -e "请输入要设置的端口 for shadowsocks-libev [1-65535]:"
    read -p "(默认端口: 16888):" shadowsocksport
    [ -z "$shadowsocksport" ] && shadowsocksport="16888"
    expr $shadowsocksport + 0 &>/dev/null
    if [ $? -eq 0 ]; then
        if [ $shadowsocksport -ge 1 ] && [ $shadowsocksport -le 65535 ]; then
            echo
            echo "---------------------------"
            echo "端口 = $shadowsocksport"
            echo "---------------------------"
            echo
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
    echo
    echo "按任意键继续安装...或 按 Ctrl+C 取消安装"
    char=`get_char`
    # Update System
    #apt-get -y update
    # Install necessary dependencies
    #apt-get install -y wget unzip curl build-essential autoconf libtool libssl-dev
    # Get IP address
    echo "Getting Public IP address, Please wait a moment..."
    IP=$(curl -s -4 icanhazip.com)
    if [[ "$IP" = "" ]]; then
        IP=$(curl -s -4 ipinfo.io/ip)
    fi
    echo -e "Your main public IP is\t\033[32m$IP\033[0m"
    echo
    #Current folder
    cur_dir=`pwd`
    cd $cur_dir
}

# Download latest shadowsocks-libev
function download_files(){
    if [ $? -eq 0 ];then
        #cd $cur_dir/shadowsocks-libev-master/
		rm -rf shadowsocks-libev-debian
        if ! wget --no-check-certificate https://raw.githubusercontent.com/wxliuxh/shadowsocks_install/master/shadowsocks-libev-debian; then
            echo "Failed to download shadowsocks-libev start script!"
            exit 1
        fi
    else
        echo
        echo "Unzip shadowsocks-libev failed! Please visit https://teddysun.com/358.html and contact."
        exit 1
    fi
}

# Config shadowsocks
function config_shadowsocks(){
    if [ ! -d /etc/shadowsocks-libev ];then
        mkdir /etc/shadowsocks-libev
    fi
    cat > /root/${shadowsocksport}.json<<-EOF
{
    "server":"0.0.0.0",
    "server_port":${shadowsocksport},
    "local_address":"127.0.0.1",
    "local_port":1080,
    "password":"${shadowsockspwd}",
    "timeout":600,
    "method":"aes-256-cfb"
}
EOF
}

# Install 
function install_libev(){
    # Build and Install shadowsocks-libev
    clear
    echo
    echo "恭喜你, shadowsocks-libev 配置文件更新完成!"
    echo -e "服务器IP: \033[41;37m ${IP} \033[0m"
    echo -e "服务器端口: \033[41;37m ${shadowsocksport} \033[0m"
    echo -e "密码: \033[41;37m ${shadowsockspwd} \033[0m"
    echo -e "本地IP: \033[41;37m 127.0.0.1 \033[0m"
    echo -e "本地端口: \033[41;37m 1080 \033[0m"
    echo -e "加密方法: \033[41;37m aes-256-cfb \033[0m"
    echo
    echo "好好享受吧!"
    echo
    exit 0
}

# Install Shadowsocks-libev
function install_shadowsocks_libev(){
    rootness
    disable_selinux
    pre_install
    download_files
    config_shadowsocks
    install_libev
}

# Uninstall Shadowsocks-libev
function uninstall_shadowsocks_libev(){
    printf "Are you sure uninstall Shadowsocks-libev? (y/n) "
    printf "\n"
    read -p "(Default: n):" answer
    if [ -z $answer ]; then
        answer="n"
    fi
    if [ "$answer" = "y" ]; then
        ps -ef | grep -v grep | grep -v ps | grep -i "ss-server" > /dev/null 2>&1
        if [ $? -eq 0 ]; then
            /etc/init.d/shadowsocks stop
        fi
        # remove auto start script
        update-rc.d -f shadowsocks remove
        # delete config file
        rm -rf /etc/shadowsocks-libev
        # delete shadowsocks
        rm -f /usr/local/bin/ss-local
        rm -f /usr/local/bin/ss-tunnel
        rm -f /usr/local/bin/ss-server
        rm -f /usr/local/bin/ss-manager
        rm -f /usr/local/bin/ss-redir
        rm -f /usr/local/lib/libshadowsocks.a
        rm -f /usr/local/lib/libshadowsocks.la
        rm -f /usr/local/include/shadowsocks.h
        rm -f /usr/local/lib/pkgconfig/shadowsocks-libev.pc
        rm -f /usr/local/share/man/man1/ss-local.1
        rm -f /usr/local/share/man/man1/ss-tunnel.1
        rm -f /usr/local/share/man/man1/ss-server.1
        rm -f /usr/local/share/man/man1/ss-manager.1
        rm -f /usr/local/share/man/man1/ss-redir.1
        rm -f /usr/local/share/man/man8/shadowsocks.8
        rm -f /etc/init.d/shadowsocks
        echo "Shadowsocks-libev uninstall success!"
    else
        echo "uninstall cancelled, Nothing to do"
    fi
}

# Initialization step
action=$1
[ -z $1 ] && action=install
case "$action" in
install)
    install_shadowsocks_libev
    ;;
uninstall)
    uninstall_shadowsocks_libev
    ;;
*)
    echo "参数错误! [${action} ]"
	echo "命令: ./`basename $0`"
	echo "或"
    echo "命令: `basename $0` {install|uninstall}"
    ;;
esac
