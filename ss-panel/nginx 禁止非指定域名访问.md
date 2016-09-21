nginx 禁止非指定域名访问

#nginx 配置如下: 
````
server {
    listen 80 default_server;
    server_name  _;
    return 404;
 
}
# server conf
server {
    listen       80;
    server_name *.yunos.com *.taobao.org ~^([0-9]+)\.([0-9]+)\.([0-9]+)\.([0-9]+)$;
     
    ...
}
````
#说明: 

nginx拿到请求后会根据$host 去匹配server_name 

如果匹配上继续走匹配的vs

如果没有匹配上走 default_server逻辑

如上default_server 404 

满足需求
