# LNMP 环境搭建

## 前置准备
- yum install -y wget
- yum install -y vim
- yum install -y ifconfig
- yum install -y net-tools
- yum install -y openssl
- yum install -y sockets
- yum install -y gcc 
- yum install -y autoconf.noarch

## php
- 源文件：php-5.6.37.tar.gz
- 安装需要的库
    + libmcrypt
        * wget ftp://mcrypt.hellug.gr/pub/crypto/mcrypt/libmcrypt/libmcrypt-2.5.7.tar.gz
        * tar -zxvf libmcrypt-2.5.7.tar.gz
        * cd libmcrypt-2.5.7
        * ./configure --prefix=/usr/local/
        * make
        * make install
    + yum install -y libxml2
    + yum install -y openssl-devel
    + yum install -y bzip2.x86_64 bzip2-devel.x86_64
    + yum install -y libcurl-devel.x86_64
    + yum install -y libpng-devel.x86_64 libpng.x86_64
    + yum install -y freetype-devel.x86_64 freetype.x86_64
    + yum install -y libtomcrypt.x86_64 libtomcrypt-devel.x86_64
    + yum install -y libxslt.x86_64 libxslt-devel.x86_64 
- 编译及安装
    - ./configure --prefix=/usr/local/php --with-openssl --enable-fpm --enable-sockets --enable-sysvshm --enable-mbstring --with-freetype-dir --with-jpeg-dir --with-png-dir --with-zlib-dir --with-libxml-dir=/usr --enable-xml --with-mhash --with-mcrypt --with-config-file-path=/usr/local/php/etc --with-config-file-scan-dir=/usr/local/php/etc --with-bz2 --with-curl --enable-exif --with-pdo-mysql --with-xsl --enable-zip --enable-mysqlnd --with-gd
    - make
    - make install
- 从安装包目录复制php.ini文件到配置目录
    + cp /acs/download/php-5.6.37/php.ini-production /usr/local/php/etc/php.ini
- 安装redis扩展
    + 下载phpredis包：phpredis-3.1.4.tar.gz
    + 解压并进入目录
    + 执行phpize生成configure文件
    + ./configure --enable-redis --with-php-config=/usr/local/bin/php-config
    + make && make install
    + 执行`php -i |grep Scan` 找到ini文件要放置的目录
    + vim redis.ini
```
extension=redis.so
```


## nginx
[参考文档](https://sharadchhetri.com/2014/07/31/how-to-install-mysql-server-5-6-on-centos-7-rhel-7/)
- 下载安装包 nginx-1.14.0.tar.gz
- 解压并进入目录
- ./configure --prefix=/usr/local
- make && make install

## mysql5.6
- 创建下载mysql的yum源文件 
    + ` wget http://repo.mysql.com/mysql-community-release-el7-5.noarch.rpm `
- 安装该rpm包
    + `rpm -ivh mysql-community-release-el7-5.noarch.rpm`
- 安装
    + `yum install -y mysql-community-server.x86_64`

## redis
- 安装源epel-release
    + `yum install -y epel-release`
- 安装
    + `yum install -y redis.x86_64`

































