# HTTPS
- 通过Let's Encrypt + Nginx 让网站升级到HTTPS


## Let's Encrypt 简介
- [网站](https://letsencrypt.org)
- 网站要启用https，就需要从证书授权机构（CA）处获取一个证书，Let's Encrypt 就是一个CA，
我们可以获得网站域名的免费证书

## Certbot简介
- [网站](https://certbot.eff.org)
- Certbot是Let's Encrypt官方推荐的获取证书的客户端，可帮我们获取免费的Let's Encrypt证书
- Certbot支持所有的Unix内核的操作系统，以下教程基于CentOS7

## 获取免费证书
- 安装Certbot客户端
```
shell> sudo yum -y install yum-utils
shell> sudo yum-config-manager --enable rhui-REGION-rhel-server-extras rhui-REGION-rhel-server-optional
shell> sudo yum install certbot-nginx
```
- 获取证书
```
shell> sudo certbot --nginx
```

## Nginx配置启用HTTPS
```
  listen 443 ssl; # managed by Certbot
  ssl_certificate /etc/letsencrypt/live/test.52funny.cn/fullchain.pem; # managed by Certbot
  ssl_certificate_key /etc/letsencrypt/live/test.52funny.cn/privkey.pem; # managed by Certbot
  include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot
  ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; # managed by Certbot
 
 
  # Redirect non-https traffic to https
  if ($scheme != "https") {
      return 301 https://$host$request_uri;
  } # managed by Certbot

```

## 自动更新SSL证书
- 配置完成后，我们的工作还没完成，Let's Encrypt提供的证书只有90天的有效期，我们必须在证书到期之前，重新获取这些证书
```
shell> sudo certbot renew
```
- 可以使用crontab自动更新
  * 新建了一个文件 certbot-auto-renew-cron， 这个是一个 cron 计划，这段内容的意思就是 每隔 两个月的 凌晨 2:15 执行 更新操作。
    ```
    15 2 * */2 * certbot renew 
    ```
  * 启动定时任务
    ```
    crontab certbot-auto-renew-cron
    ```
