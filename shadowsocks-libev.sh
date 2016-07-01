#! /bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
#===============================================================================================
#   System Required:  CentOS6.x (32bit/64bit)
#   Description: Install Shadowsocks-libev server for CentOS 6
#   Author: Teddysun <i@teddysun.com>
#   Thanks: @m0d8ye <https://twitter.com/m0d8ye>
#   Intro:  https://teddysun.com/357.html
#===============================================================================================

clear
echo "#############################################################"
echo -e "# 请注意!本安装脚本 \033[40;31m仅支持 CentOS 6\033[0m 系统                    #"
echo "# shadowsocks-libev 定制版安装                              #"
echo "# Author: wxliuxh                                           #"
echo "#############################################################"
echo ""

# Make sure only root can run our script
function rootness(){
if [[ $EUID -ne 0 ]]; then
   echo "错误:此脚本必须以root身份运行!" 1>&2
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
        echo "不支持CentOS 5与CentOS 7，请更改至CentOS 6，然后再试一次."
        exit 1
    fi
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
    echo "按任意键继续安装或更新...或 按 Ctrl+C 取消安装"
    char=`get_char`
    #Install necessary dependencies
    rm -f /etc/localtime
    cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
    yum install -y wget unzip openssl-devel gcc swig python python-devel python-setuptools autoconf libtool libevent
    yum install -y automake make curl curl-devel zlib-devel openssl-devel perl perl-devel cpio expat-devel gettext-devel
    # Get IP address
    echo "获取公网IP地址，请稍候..."
    IP=$(curl -s -4 icanhazip.com)
    if [[ "$IP" = "" ]]; then
        IP=`curl -s -4 ipinfo.io/ip`
    fi
    echo -e "你的首选公网IP是 \t\033[32m$IP\033[0m"
    echo ""
    #Current folder
    cur_dir=`pwd`
    cd $cur_dir
}

function supervisord_install(){
	easy_install supervisor
	chmod 755 /etc/init.d/supervisord
	chkconfig supervisord on
	#service supervisord start
}

# Download latest shadowsocks-libev
function download_files(){
    rm -f shadowsocks-libev.zip
    if [ -f shadowsocks-libev.zip ];then
        echo "shadowsocks-libev.zip [存在]"
    else
        if ! wget --no-check-certificate https://github.com/shadowsocks/shadowsocks-libev/archive/master.zip -O shadowsocks-libev.zip;then
            echo "无法下载 shadowsocks-libev.zip"
            exit 1
        fi
    fi
    unzip shadowsocks-libev.zip
    if [ $? -eq 0 ];then
        cd $cur_dir/shadowsocks-libev-master/
    else
        echo ""
        echo "解压缩 shadowsocks-libev 失败!"
        exit 1
    fi
}

function download_script(){
	    # 守护程序
    if ! wget --no-check-certificate https://raw.githubusercontent.com/wxliuxh/shadowsocks_install/master/supervisord/supervisord.conf -O /etc/supervisord.conf; then
        echo "无法下载 supervisord.conf 脚本!"
        exit 1
    fi
	    # 守护程序
    if ! wget --no-check-certificate https://raw.githubusercontent.com/wxliuxh/supervisord/master/supervisord -O /etc/init.d/supervisord; then
        echo "无法下载 supervisord 脚本!"
        exit 1
    fi
	    # ulimit 修改
    if ! wget --no-check-certificate https://raw.githubusercontent.com/wxliuxh/shadowsocks_install/master/limits.conf -O /etc/security/limits.conf; then
        echo "无法下载 limits.conf 脚本!"
        exit 1
    fi
	    # 下载256加密脚本
    if ! wget --no-check-certificate https://raw.githubusercontent.com/wxliuxh/shadowsocks_install/master/shadowsocks-libev-add-256.sh  -O /root/add256.sh; then
        echo "无法下载 shadowsocks-libev-add-256.sh 脚本!"
        exit 1
    fi
	    # 下载cha20加密脚本
    if ! wget --no-check-certificate https://raw.githubusercontent.com/wxliuxh/shadowsocks_install/master/shadowsocks-libev-add-cha20.sh  -O /root/add20.sh; then
        echo "无法下载 shadowsocks-libev-add-cha20.sh 脚本!"
        exit 1
    fi
}

# Install 
function install(){
    chmod +x /root/add256.sh
    chmod +x /root/add20.sh
    # Build and Install shadowsocks-libev
    ./configure
    make && make install
    if [ $? -eq 0 ]; then
        mv $cur_dir/shadowsocks-libev-master/shadowsocks-libev /etc/init.d/shadowsocks
        chmod +x /etc/init.d/shadowsocks
        # Add run on system start up
        chkconfig --add shadowsocks
        chkconfig shadowsocks on
        # Start shadowsocks
        /etc/init.d/shadowsocks start
    if [ $? -eq 0 ]; then
        echo "Shadowsocks-libev 启动 成功!"
    else
        echo "Shadowsocks-libev 启动 失败!"
        fi
    else
        echo ""
        echo "Shadowsocks-libev 安装失败!."
        exit 1
    fi
    cd $cur_dir
    # Delete shadowsocks-libev floder
    rm -rf $cur_dir/shadowsocks-libev-master/
    # Delete shadowsocks-libev zip file
    rm -f shadowsocks-libev.zip
    /etc/init.d/shadowsocks stop
    chkconfig --del shadowsocks
    rm -f /etc/init.d/shadowsocks
    clear
    echo ""
    echo "恭喜, shadowsocks-libev 定制版安装完成!"
    echo "请运行 ./add20.sh 或 ./add256.sh 添加/删除端口"
    echo ""
    exit 0
}

# Uninstall Shadowsocks-libev
function uninstall_shadowsocks_libev(){
    printf "你真的要卸载shadowsocks_libev吗? (y/n) "
    printf "\n"
    read -p "(默认为: n):" answer
    if [ -z $answer ]; then
        answer="n"
    fi
    if [ "$answer" = "y" ]; then
        ps -ef | grep -v grep | grep -v ps | grep -i "ss-server" > /dev/null 2>&1
        if [ $? -eq 0 ]; then
            /etc/init.d/shadowsocks stop
        fi
        chkconfig --del shadowsocks
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
        clear
        echo "Shadowsocks-libev 卸载 成功!"
    else
    	clear
        echo "卸载取消，本次操作无任何修改"
    fi
}

# Install Shadowsocks-libev
function install_shadowsocks_libev(){
    rootness
    disable_selinux
    pre_install
    download_files
    download_script
    supervisord_install
    install
}

function upscript_shadowsocks_libev(){
    rootness
    disable_selinux
    download_script
    chmod 755 /etc/init.d/supervisord
    chmod +x /root/add256.sh
    chmod +x /root/add20.sh
    clear
    echo "脚本更新成功."
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
upscript)
    upscript_shadowsocks_libev
    ;;
*)
    echo "参数错误! [${action} ]"
    echo "命令: `basename $0` {install|uninstall|upscript}"
    ;;
esac
