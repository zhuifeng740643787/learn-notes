# 后端机器配置

## 服务控制
- `/etc/init.d/nginx test` 测试配置文件是否有语法错误
- `/etc/init.d/nginx status` 查看服务状态
- `/etc/init.d/nginx start` 启动服务
- `/etc/init.d/nginx stop` 停止服务
- `/etc/init.d/nginx restart` 重启服务
- `/etc/init.d/nginx reload` 平滑重启服务

## /etc/nginx/nginx.conf
```
user  www;
worker_processes  16;
worker_rlimit_nofile 65535;

pid        /var/run/nginx.pid;

events {
    worker_connections  10240;
}


http {
    include       /etc/nginx/mime.types;

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
    keepalive_requests 10000;

    client_max_body_size 512m;
    client_body_buffer_size 5m;

    client_header_timeout 3600s;
    client_body_timeout 3600s;

    #fastcgi
    fastcgi_read_timeout 3600s;
    fastcgi_send_timeout 3600s;

    fastcgi_buffer_size 128k;
    fastcgi_buffers 32 32k;
    fastcgi_max_temp_file_size 1024m;

    proxy_read_timeout 3600s;
    proxy_send_timeout 3600s;

    fastcgi_ignore_client_abort on;
    proxy_ignore_client_abort  on;

    include /etc/nginx/conf.d/*.conf;

}

```

# /etc/nginx/conf.d/www.conf
```
server {
        listen       80;
        listen       443;
        server_name  xxx.com;
        root         /acs/code;
        index        index.php index.html;
        charset      utf-8;

        error_page   403 http://xxx.com/error_pages/403.html;
        error_page   404 http://xxx.com/error_pages/404.html;
        error_page   500 http://xxx.com/error_pages/500.html;
        error_page   502 http://xxx.com/error_pages/502.html;
        error_page   503 http://xxx.com/error_pages/503.html;
        error_page   504 http://xxx.com/error_pages/504.html;

        location ~* \.(tar|log)$ {
            deny all;
            access_log off;
            return 403 "Forbidden!";
        }
        location ~* \.(js|css|png|jpg|jpeg|gif|ico|swf)$ {
            access_log off;
            expires 10d;
        }

        fastcgi_intercept_errors on;
        location ~ \.php$ {
            fastcgi_pass   127.0.0.1:9000;
            fastcgi_index  index.php;
            fastcgi_split_path_info     ^(.+\.php)(/.*)$;
            include        /etc/nginx/fastcgi_params;
            keepalive_timeout     0;
            fastcgi_param  PATH_INFO    $fastcgi_script_name;
            fastcgi_param  SCRIPT_FILENAME  $document_root$fastcgi_script_name;
        }

    }
```
