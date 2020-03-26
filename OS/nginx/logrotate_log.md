# nginx日志切割备份
- 编辑配置文件
```
root> vim /etc/logrotate.d/nginx
/acs/log/nginx_log/*.log { 
        daily
        dateext
        missingok
        rotate 30 
        compress
        nodelaycompress
        notifempty
        create 644 staff staff 
        sharedscripts
        olddir /acs/log/nginx_log/bak
        postrotate
                if [ -f /var/run/nginx.pid ]; then 
                        kill -USR1 `cat /var/run/nginx.pid` 
                fi
        endscript
}

```
- 说明
    + /acs/log/nginx_log/*.log 日志路径
    + rotate 30                保留多少个文件
    + create 644 staff staff       文件权限及创建者


- 创建定时任务
```
root> crontab -e
#nginx 日志切割
59 23 * * * /usr/sbin/logrotate -f /etc/logrotate.d/nginx /dev/null 2>&1
```