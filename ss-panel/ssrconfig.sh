#! /bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
#===============================================================================================
#   ss panel v3 一键配置http api
#===============================================================================================

clear
echo "#############################################################"
echo "#     ss panel v3 一键配置http api        仅需填写节点      #"
echo "#     配置之前请先确保已安装 shadowsocksR                   #"
echo "#############################################################"
echo ""

#网站
weburl="https://你的网站"
#密钥
webtoken="你的密钥"
#测速时间
speed="0"
#不知道干啥的-不要加http和尾部/
MU_SUFFIX="你的网站"

# 检测权限是否 root
function rootness(){
if [[ $EUID -ne 0 ]]; then
   echo "错误:请用 root 权限执行 !" 1>&2
   exit 1
fi
}

# 正文
function pre_install(){
    echo ""
    echo "请输入数字ID:"
    echo "按 Ctrl+C 取消"
    echo ""
    read -p "(默认ID: 3):" webid
    [ -z "$webid" ] && webid="3"
    echo ""
    echo "---------------------------"
    echo "当前配置ID = $webid"
    echo "---------------------------"
    echo ""
    echo ""
    echo "按任意键继续...或 按 Ctrl+C 取消"
}

# 配置 userapiconfig.py
function config_userapiconfig(){
    #先删除缓存
    rm -rf /root/shadowsocks/*.pyc
    #写出配置
    cat > /root/shadowsocks/userapiconfig.py<<-EOF
# Config
NODE_ID = ${webid}


# hour,set 0 to disable
SPEEDTEST = ${speed}
CLOUDSAFE = 1
ANTISSATTACK = 0
AUTOEXEC = 0

MU_SUFFIX = '${MU_SUFFIX}'
MU_REGEX = '%5m%id.%suffix'

SERVER_PUB_ADDR = '127.0.0.1'  # mujson_mgr need this to generate ssr link
API_INTERFACE = 'modwebapi'  # glzjinmod, modwebapi

WEBAPI_URL = '${weburl}'
WEBAPI_TOKEN = '${webtoken}'

# mudb
MUDB_FILE = 'mudb.json'

# Mysql
MYSQL_HOST = '127.0.0.1'
MYSQL_PORT = 3306
MYSQL_USER = 'ss'
MYSQL_PASS = 'ss'
MYSQL_DB = 'shadowsocks'

MYSQL_SSL_ENABLE = 0
MYSQL_SSL_CA = ''
MYSQL_SSL_CERT = ''
MYSQL_SSL_KEY = ''

# API
API_HOST = '127.0.0.1'
API_PORT = 80
API_PATH = '/mu/v2/'
API_TOKEN = 'abcdef'
API_UPDATE_TIME = 60

# Manager (ignore this)
MANAGE_PASS = 'ss233333333'
# if you want manage in other server you should set this value to global ip
MANAGE_BIND_IP = '127.0.0.1'
# make sure this port is idle
MANAGE_PORT = 23333

# Safety
IP_MD5_SALT = 'randomforsafety'

EOF
}


# Install 
function install(){
    #supervisord 守护进程.我自己需要用.你不用的话自己加注释
	service supervisord restart
    clear
    echo ""
    echo "http api +ID 配置成功!"
    echo ""
    echo -e "服务器ID: \033[41;37m ${webid} \033[0m"
    echo ""
    echo "好好享受吧!"
    echo ""
    curl ${weburl}/mod_mu/func/ping?key=${webtoken}
    echo ""
    echo "出现 pong 即为成功!"
    exit 0
}

# Install shadowsocksR
function config_shadowsocksR(){
    rootness
    pre_install
    config_userapiconfig
    install
}

# Initialization step
action=$1
[ -z $1 ] && action=add
case "$action" in
add)
    config_shadowsocksR
    ;;
*)
    echo "参数错误! [${action} ]"
    echo "安装命令: ./`basename $0`"
    ;;
esac
