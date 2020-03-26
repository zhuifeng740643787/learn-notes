#!/bin/bash

# 打印日志
function printLog() {
  echo $1
}

printLog '开始....'
printLog '下载并解压安装包..'
mkdir -p /acs/data/download && cd /acs/data/download && wget https://xxx.com/common/php72.tar.gz?Expires=1591924453&OSSAccessKeyId=LTAIa1UEITFafaL8&Signature=OTIcuIi6%2FzdVRcs8v%2BkAeeDwWWs%3D -O php72.tar.gz && tar -zxvf php72.tar.gz
cd /acs/data/download/php72 && tar -zxvf php-7.2.17.tar.gz && tar -zxvf php72-mcrypt-1.0.2.tgz && tar -zxvf php72-redis-4.3.9.tgz

printLog '安装需要的库....'
yum install -y gcc gcc-c++ pcre-devel.x86_64 openssl-devel.x86_64 libxml2-devel.x86_64 bzip2-devel.x86_64 libcurl-devel.x86_64 libjpeg-devel.x86_64 libpng-devel.x86_64 freetype-devel.x86_64 libxslt-devel.x86_64 libzip-devel.x86_64

printLog '安装PHP....'
cd /acs/data/download/php72/php-7.2.17
yum install -y readline.x86_64  readline-devel.x86_64
./configure  --prefix=/usr/local/php72 --with-openssl --enable-fpm --enable-sockets --enable-sysvshm --enable-mbstring --with-freetype-dir --with-jpeg-dir --with-png-dir --with-zlib-dir --with-libxml-dir=/usr --enable-xml --with-mhash --with-config-file-path=/usr/local/php72/etc --with-config-file-scan-dir=/usr/local/php72/etc/conf.d --with-readline --with-bz2 --with-curl --enable-exif --with-mysqli=mysqlnd --with-pdo-mysql=mysqlnd --with-mysql-sock=/tmp/mysql.sock --with-xsl --enable-zip --enable-mysqlnd --with-gd --enable-soap --enable-pcntl
make && make install

printLog '修改配置文件php.ini ....'
cd /usr/local/php72/etc && cp /acs/data/download/php72/php-7.2.17/php.ini-production /usr/local/php72/etc/php.ini
sed -i 's/;*upload_max_filesize.*/upload_max_filesize = 20M/g' /usr/local/php72/etc/php.ini
sed -i 's/;*post_max_size.*/post_max_size = 20M/g' /usr/local/php72/etc/php.ini
sed -i 's/;*max_execution_time.*/max_execution_time = 600/g' /usr/local/php72/etc/php.ini
sed -i 's/;*max_input_time.*/max_input_time = 60/g' /usr/local/php72/etc/php.ini
sed -i 's/;*max_input_vars.*/max_input_vars = 10000/g' /usr/local/php72/etc/php.ini
sed -i 's/;*memory_limit.*/memory_limit = 512M/g' /usr/local/php72/etc/php.ini
sed -i 's/;*session.auto_start.*/session.auto_start = 0/g' /usr/local/php72/etc/php.ini

printLog '修改配置文件php-fpm....'
mkdir -p /acs/log/php72-fpm
cd /usr/local/php72/etc && mv php-fpm.conf.default php-fpm.conf
sed -i 's/;*pid =.*/pid = \/var\/run\/php72-fpm.pid/g' /usr/local/php72/etc/php-fpm.conf
sed -i 's/;*error_log =.*/error_log = \/acs\/log\/php72-fpm\/error\.log/g' /usr/local/php72/etc/php-fpm.conf
sed -i 's/;*daemonize =.*/daemonize = yes/g' /usr/local/php72/etc/php-fpm.conf
sed -i 's/;*rlimit_files =.*/rlimit_files = 10240/g' /usr/local/php72/etc/php-fpm.conf
mv /usr/local/php72/etc/php-fpm.d/www.conf.default /usr/local/php72/etc/php-fpm.d/www.conf
sed -i 's/;*\[www\]/\[www\-72\]/g' /usr/local/php72/etc/php-fpm.d/www.conf 
sed -i 's/;*user =.*/user = www/g' /usr/local/php72/etc/php-fpm.d/www.conf
sed -i 's/;*group =.*/group = www/g' /usr/local/php72/etc/php-fpm.d/www.conf
sed -i 's/;*listen =.*/listen = 127.0.0.1:9072/g' /usr/local/php72/etc/php-fpm.d/www.conf
sed -i 's/;*pm =.*/pm = static/g' /usr/local/php72/etc/php-fpm.d/www.conf
sed -i 's/;*pm\.max_children =.*/pm\.max_children = 200/g' /usr/local/php72/etc/php-fpm.d/www.conf
sed -i 's/;*pm\.start_servers =.*/pm\.start_servers = 16/g' /usr/local/php72/etc/php-fpm.d/www.conf
sed -i 's/;*pm\.min_spare_servers =.*/pm\.min_spare_servers = 12/g' /usr/local/php72/etc/php-fpm.d/www.conf
sed -i 's/;*pm\.max_spare_servers =.*/pm\.max_spare_servers = 24/g' /usr/local/php72/etc/php-fpm.d/www.conf
sed -i 's/;*pm\.status_path =.*/pm\.status_path= \/php72_fpm_status/g' /usr/local/php72/etc/php-fpm.d/www.conf

printLog '安装mcrypt扩展....'
cd /acs/data/download/php72/mcrypt-1.0.2
/usr/local/php72/bin/phpize
./configure --with-mcrypt --with-php-config=/usr/local/php72/bin/php-config
make && make install
mkdir -p /usr/local/php72/etc/conf.d && echo extension=mcrypt.so > /usr/local/php72/etc/conf.d/mcrypt.ini

printLog '安装redis扩展....'
cd /acs/data/download/php72/redis-4.3.0
./configure  --enable-redis --with-php-config=/usr/local/php72/bin/php-config
make && make install
mkdir -p /usr/local/php72/etc/conf.d && echo extension=redis.so > /usr/local/php72/etc/conf.d/redis.ini

printLog '复制执行文件到环境变量目录....'
cp /usr/local/php72/bin/php /usr/local/bin/php72
cp /usr/local/php72/sbin/php-fpm /usr/local/sbin/php72-fpm

printLog '创建php-fpm进程管理文件/etc/init.d/php72-fpm并启动...'
fpm_init_bin='/etc/init.d/php72-fpm'
cat>"${fpm_init_bin}"<<EOF
#!/bin/bash
prefix=/usr/local/php72
exec_prefix=\${prefix}
php_fpm_BIN=\${exec_prefix}/sbin/php-fpm
php_fpm_CONF=\${prefix}/etc/php-fpm.conf
php_fpm_PID=/var/run/php72-fpm.pid
php_opts="--fpm-config \$php_fpm_CONF --pid \$php_fpm_PID"
wait_for_pid () {
        try=0
        while test \$try -lt 35 ; do
                case "\$1" in
                        'created')
                        if [ -f "\$2" ] ; then
                                try=''
                                break
                        fi
                        ;;

                        'removed')
                        if [ ! -f "\$2" ] ; then
                                try=''
                                break
                        fi
                        ;;
                esac

                echo -n .
                try=\`expr \$try + 1\`
                sleep 1

        done

}

case "\$1" in
        start)
                echo -n "Starting php72-fpm "

                \$php_fpm_BIN --daemonize \$php_opts

                if [ "\$?" != 0 ] ; then
                        echo " failed"
                        exit 1
                fi

                wait_for_pid created \$php_fpm_PID

                if [ -n "\$try" ] ; then
                        echo " failed"
                        exit 1
                else
                        echo " done"
                fi
        ;;

        stop)
                echo -n "Gracefully shutting down php72-fpm "

                if [ ! -r \$php_fpm_PID ] ; then
                        echo "warning, no pid file found - php72-fpm is not running ?"
                        exit 1
                fi

                kill -QUIT \`cat \$php_fpm_PID\`

                wait_for_pid removed \$php_fpm_PID

                if [ -n "\$try" ] ; then
                        echo " failed. Use force-quit"
                        exit 1
                else
                        echo " done"
                fi
        ;;

        status)
                if [ ! -r \$php_fpm_PID ] ; then
                        echo "php72-fpm is stopped"
                        exit 0
                fi

                PID=\`cat \$php_fpm_PID\`
                if ps -p \$PID | grep -q \$PID; then
                        echo "php72-fpm (pid \$PID) is running..."
                else
                        echo "php72-fpm dead but pid file exists"
                fi
        ;;

        force-quit)
                echo -n "Terminating php72-fpm "

                if [ ! -r \$php_fpm_PID ] ; then
                        echo "warning, no pid file found - php72-fpm is not running ?"
                        exit 1
                fi

                kill -TERM \`cat \$php_fpm_PID\`

                wait_for_pid removed \$php_fpm_PID

                if [ -n "\$try" ] ; then
                        echo " failed"
                        exit 1
                else
                        echo " done"
                fi
        ;;

        restart)
                \$0 stop
                \$0 start
        ;;

        reload)

                echo -n "Reload service php72-fpm "

                if [ ! -r \$php_fpm_PID ] ; then
                        echo "warning, no pid file found - php72-fpm is not running ?"
                        exit 1
                fi

                kill -USR2 \`cat \$php_fpm_PID\`

                echo " done"
        ;;

        *)
                echo "Usage: \$0 {start|stop|force-quit|restart|reload|status}"
                exit 1
        ;;
esac
EOF
printLog '添加执行权限并启动php-fpm'
chmod a+x $fpm_init_bin
$fpm_init_bin start

