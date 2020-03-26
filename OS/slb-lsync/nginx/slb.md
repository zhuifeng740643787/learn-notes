# 负载均衡配置

## 服务控制
- `/etc/init.d/nginx test` 测试配置文件是否有语法错误
- `/etc/init.d/nginx status` 查看服务状态
- `/etc/init.d/nginx start` 启动服务
- `/etc/init.d/nginx stop` 停止服务
- `/etc/init.d/nginx restart` 重启服务
- `/etc/init.d/nginx reload` 平滑重启服务

## 设置/etc/hosts, 使用内网访问后端机器
```
192.168.5.1      host1
192.168.5.2      host2
192.168.5.3      host3
```

## /etc/nginx/nginx.conf
```
user  www;
worker_processes  8;
worker_rlimit_nofile 65535;

pid   /var/run/nginx.pid;

events {
    worker_connections  10240;
}


http {
    include   /etc/nginx/mime.types;

    log_format main '$request_time $upstream_response_time $remote_addr - $upstream_addr  [$time_local] '
                    '$host "$request" $status $bytes_sent '
                    '"$http_referer" "$http_user_agent" "$gzip_ratio" "$http_x_forwarded_for" - "$server_addr"';
    access_log  /acs/log/nginx_log/access.log  main;
    error_log   /acs/log/nginx_log/error.log error;

    sendfile        on;
    #tcp_nopush     on;
    gzip  on;

    #keepalive_timeout  0;
    keepalive_timeout  120;

    client_max_body_size 512m;
    client_body_buffer_size 5m;

    client_header_timeout 300s;
    client_body_timeout 300s;


    include /etc/nginx/conf.d/*.conf;
}
```

## /etc/nginx/conf.d/www.conf
```
 # 负载均衡
    upstream xxx__backend {
        server host1:80 weight=1;
        server host2:80 weight=2;
        server host3:80 backup;
    }

    # 代理设置
    proxy_set_header   Host             $host;
    proxy_set_header   X-Real-IP        $remote_addr;
    proxy_set_header   X-Forwarded-For  $proxy_add_x_forwarded_for;
    proxy_connect_timeout  1800s;  # nginx跟后端服务器连接超时时间(代理连接超时)
    proxy_send_timeout      1800s;  # 后端服务器数据回传时间(代理发送超时)
    proxy_read_timeout      1800s;  # 连接成功后，后端服务器响应时间(代理接收超时)
    proxy_buffer_size        64k;  # 设置代理服务器（nginx）保存用户头信息的缓冲区大小
    proxy_buffers         4 128k;  # proxy_buffers缓冲区，网页平均在32k以下的设置
    proxy_busy_buffers_size 256k;  # 高负荷下缓冲大小（proxy_buffers*2）
    proxy_temp_file_write_size 128k; # 设定缓存文件夹大小，大于这个值，将从upstream服务器传
    proxy_buffering         off;
    proxy_ignore_client_abort on;

    server {
        listen       80;
        server_name  xxx.com;
        # 强制 HTTP 跳转至 HTTPS
        location / {
            # host 与 server_name 等价, redirect/permanent 分别为临时跳转/永久跳转
            rewrite ^(.*)$  https://$host$1 permanent;
        }
    }

    server {
        listen       443 ssl;
        server_name  xxx.com;
        charset      utf-8;

        ssl_certificate      /etc/nginx/ssl/xxx_cert.pem;
        ssl_certificate_key  /etc/nginx/ssl/xxx_cert.key;

        ssl_session_cache    shared:SSL:1m;
        ssl_session_timeout  5m;

        ssl_ciphers  HIGH:!aNULL:!MD5;
        ssl_prefer_server_ciphers  on;

        location / {
            proxy_pass http://xxx__backend;
        }

        location ~ /error_pages {
           root /acs/code;
           index index.html;
        }

        location ~* \.(tar|log)$ {
            deny all;
            access_log off;
            return 403 "Forbidden!";
        }
        location ~* \.(js|css|png|jpg|jpeg|gif|ico|swf|js\.map)$ {
            access_log off;
            expires 10d;
            proxy_pass http://xxx__backend;
        }
    }
```
