#!/bin/bash

# 打印日志
function printLog() {
  echo $1
}

printLog '开始....'
# printLog '下载并解压安装包..'
cd /acs/data/download/ && tar -zxvf php73.tar.gz && cd ./php73 && tar -zxvf php-7.3.9.tar.gz && tar -zxvf mcrypt-1.0.2.tgz && tar -zxvf redis-4.3.0.tgz && tar -zxvf nsq-3.5.0.tgz && tar -zxvf xlswriter-1.3.3.2.tgz

# printLog '安装需要的库....'
yum install -y gcc.x86_64 pcre-devel.x86_64 openssl-devel.x86_64 libxml2-devel.x86_64 bzip2-devel.x86_64 libcurl-devel.x86_64 libjpeg-devel.x86_64 libpng-devel.x86_64 freetype-devel.x86_64 libxslt-devel.x86_64 libzip-devel.x86_64  readline-devel.x86_64 pcre-devel.x86_64 autoconf.noarch libmcrypt-devel.x86_64 libevent-devel.x86_64 libjpeg-turbo-devel.x86_64 openjpeg-devel.x86_64

printLog '更新libzip'
# wget https://libzip.org/download/libzip-1.3.2.tar.gz
tar -zxvf libzip-1.3.2.tar.gz
yum remove libzip -y
cd libzip-1.3.2
./configure
make && make install

printLog '安装PHP....'
cd /acs/data/download/php73/php-7.3.9
./configure  --prefix=/usr/local/php73 --with-openssl --enable-fpm --enable-sockets --enable-sysvshm --enable-mbstring --with-freetype-dir --with-jpeg-dir --with-png-dir --with-zlib-dir --with-libxml-dir=/usr --enable-xml --with-mhash --with-config-file-path=/usr/local/php73/etc --with-config-file-scan-dir=/usr/local/php73/etc/conf.d --with-readline --with-bz2 --with-curl --enable-exif --with-mysqli=mysqlnd --with-pdo-mysql=mysqlnd --with-mysql-sock=/tmp/mysql.sock --with-xsl --enable-zip --enable-mysqlnd --with-gd --enable-soap --enable-pcntl --enable-bcmath
make && make install

printLog '修改配置文件php.ini ....'
cd /usr/local/php73/etc && cp /acs/data/download/php73/php-7.3.9/php.ini-production /usr/local/php73/etc/php.ini 
sed -i 's/;*upload_max_filesize.*/upload_max_filesize = 20M/g' /usr/local/php73/etc/php.ini
sed -i 's/;*post_max_size.*/post_max_size = 20M/g' /usr/local/php73/etc/php.ini
sed -i 's/;*max_execution_time.*/max_execution_time = 600/g' /usr/local/php73/etc/php.ini
sed -i 's/;*max_input_time.*/max_input_time = 60/g' /usr/local/php73/etc/php.ini
sed -i 's/;*max_input_vars.*/max_input_vars = 10000/g' /usr/local/php73/etc/php.ini
sed -i 's/;*memory_limit.*/memory_limit = 512M/g' /usr/local/php73/etc/php.ini
sed -i 's/;*session.auto_start.*/session.auto_start = 0/g' /usr/local/php73/etc/php.ini

printLog '修改配置文件php-fpm....'
mkdir -p /acs/log/php73-fpm
cd /usr/local/php73/etc && mv php-fpm.conf.default php-fpm.conf
sed -i 's/;*pid =.*/pid = \/var\/run\/php73-fpm.pid/g' /usr/local/php73/etc/php-fpm.conf
sed -i 's/;*error_log =.*/error_log = \/acs\/log\/php73-fpm\/error\.log/g' /usr/local/php73/etc/php-fpm.conf
sed -i 's/;*daemonize =.*/daemonize = yes/g' /usr/local/php73/etc/php-fpm.conf
sed -i 's/;*rlimit_files =.*/rlimit_files = 10240/g' /usr/local/php73/etc/php-fpm.conf
mv /usr/local/php73/etc/php-fpm.d/www.conf.default /usr/local/php73/etc/php-fpm.d/www.conf
sed -i 's/;*\[www\]/\[www\-73\]/g' /usr/local/php73/etc/php-fpm.d/www.conf 
sed -i 's/;*user =.*/user = www/g' /usr/local/php73/etc/php-fpm.d/www.conf
sed -i 's/;*group =.*/group = www/g' /usr/local/php73/etc/php-fpm.d/www.conf
sed -i 's/;*listen =.*/listen = 127.0.0.1:9073/g' /usr/local/php73/etc/php-fpm.d/www.conf
sed -i 's/;*pm =.*/pm = static/g' /usr/local/php73/etc/php-fpm.d/www.conf
sed -i 's/;*pm\.max_children =.*/pm\.max_children = 50/g' /usr/local/php73/etc/php-fpm.d/www.conf
sed -i 's/;*pm\.start_servers =.*/pm\.start_servers = 16/g' /usr/local/php73/etc/php-fpm.d/www.conf
sed -i 's/;*pm\.min_spare_servers =.*/pm\.min_spare_servers = 12/g' /usr/local/php73/etc/php-fpm.d/www.conf
sed -i 's/;*pm\.max_spare_servers =.*/pm\.max_spare_servers = 24/g' /usr/local/php73/etc/php-fpm.d/www.conf
sed -i 's/;*pm\.status_path =.*/pm\.status_path= \/php73_fpm_status/g' /usr/local/php73/etc/php-fpm.d/www.conf

printLog '安装mcrypt扩展....'
cd /acs/data/download/php73/mcrypt-1.0.2
/usr/local/php73/bin/phpize
./configure --with-mcrypt --with-php-config=/usr/local/php73/bin/php-config
make && make install
mkdir -p /usr/local/php73/etc/conf.d && echo extension=mcrypt.so > /usr/local/php73/etc/conf.d/mcrypt.ini

printLog '安装redis扩展....'
cd /acs/data/download/php73/redis-4.3.0
/usr/local/php73/bin/phpize
./configure  --enable-redis --with-php-config=/usr/local/php73/bin/php-config
make && make install
mkdir -p /usr/local/php73/etc/conf.d && echo extension=redis.so > /usr/local/php73/etc/conf.d/redis.ini

printLog '安装nsq扩展....'
cd /acs/data/download/php73/nsq-3.5.0
/usr/local/php73/bin/phpize
./configure  --with-nsq --with-php-config=/usr/local/php73/bin/php-config
make && make install
mkdir -p /usr/local/php73/etc/conf.d && echo extension=nsq.so > /usr/local/php73/etc/conf.d/nsq.ini

printLog '安装xlswriter扩展....'
cd /acs/data/download/php73xlswriter-1.3.3.2/
/usr/local/php73/bin/phpize
./configure  --enable-reader --enable-xlswriter --with-php-config=/usr/local/php73/bin/php-config
make && make install
mkdir -p /usr/local/php73/etc/conf.d && echo extension=xlswriter.so > /usr/local/php73/etc/conf.d/xlswriter.ini

printLog '复制执行文件到环境变量目录....'
cp /usr/local/php73/bin/php /usr/local/bin/php73
cp /usr/local/php73/sbin/php-fpm /usr/local/sbin/php73-fpm

printLog '创建php-fpm进程管理文件/etc/init.d/php73-fpm并启动...'
fpm_init_bin='/etc/init.d/php73-fpm'
cat>"${fpm_init_bin}"<<EOF
#!/bin/bash
prefix=/usr/local/php73
exec_prefix=\${prefix}
php_fpm_BIN=\${exec_prefix}/sbin/php-fpm
php_fpm_CONF=\${prefix}/etc/php-fpm.conf
php_fpm_PID=/var/run/php73-fpm.pid
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
                echo -n "Starting php73-fpm "

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
                echo -n "Gracefully shutting down php73-fpm "

                if [ ! -r \$php_fpm_PID ] ; then
                        echo "warning, no pid file found - php73-fpm is not running ?"
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
                        echo "php73-fpm is stopped"
                        exit 0
                fi

                PID=\`cat \$php_fpm_PID\`
                if ps -p \$PID | grep -q \$PID; then
                        echo "php73-fpm (pid \$PID) is running..."
                else
                        echo "php73-fpm dead but pid file exists"
                fi
        ;;

        force-quit)
                echo -n "Terminating php73-fpm "

                if [ ! -r \$php_fpm_PID ] ; then
                        echo "warning, no pid file found - php73-fpm is not running ?"
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

                echo -n "Reload service php73-fpm "

                if [ ! -r \$php_fpm_PID ] ; then
                        echo "warning, no pid file found - php73-fpm is not running ?"
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

