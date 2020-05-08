#!/bin/bash

# 打印日志
function printLog() {
  echo $1
}

printLog '开始....'
printLog '安装系统库....'
yum install -y gcc.x86_64 vim-enhanced.x86_64 pcre-devel.x86_64 openssl-devel.x86_64 libxml2-devel.x86_64 bzip2-devel.x86_64 libcurl-devel.x86_64 libjpeg-devel.x86_64 libpng-devel.x86_64 freetype-devel.x86_64 libxslt-devel.x86_64 libzip-devel.x86_64  readline-devel.x86_64 pcre-devel.x86_64 autoconf.noarch libmcrypt-devel.x86_64

cd /acs/data/download/ && tar -zxvf nginx-1.17.4.tar.gz && cd ./nginx-1.17.4 

printLog '安装nginx....'
cd /acs/data/download/nginx-1.17.4 
./configure --prefix=/usr/local/nginx --sbin-path=/usr/local/nginx/sbin/nginx --conf-path=/etc/nginx/nginx.conf --error-log-path=/usr/local/nginx/log/error.log --http-log-path=/usr/local/nginx/log/access.log --pid-path=/var/run/nginx/nginx.pid --lock-path=/var/lock/nginx.lock --user=nginx --group=nginx --with-http_ssl_module --with-http_flv_module --with-http_stub_status_module --with-http_gzip_static_module --http-client-body-temp-path=/var/tmp/nginx/client/ --http-proxy-temp-path=/var/tmp/nginx/proxy/ --http-fastcgi-temp-path=/var/tmp/nginx/fcgi/ --http-uwsgi-temp-path=/var/tmp/nginx/uwsgi --http-scgi-temp-path=/var/tmp/nginx/scgi --with-pcre
make && make install

printLog '为执行文件创建软链....'
ln -s /usr/local/nginx/sbin/nginx /usr/local/sbin/nginx

printLog '创建nginx进程管理文件/etc/init.d/nginx并启动...'
mkdir -p /var/tmp/nginx/client/
nginx_init_bin='/etc/init.d/nginx'
cat>"${nginx_init_bin}"<<EOF
#!/bin/bash
# chkconfig: - 85 15
PATH=/usr/local/nginx
DESC="nginx daemon"
NAME=nginx
DAEMON=\${PATH}/sbin/\${NAME}
CONFIGFILE=\${PATH}/conf/\${NAME}.conf
PIDFILE=/var/run/\${NAME}.pid
SCRIPTNAME=/etc/init.d/\${NAME}
set -e
[ -x "\${DAEMON}" ] || exit 0
do_start() {
\${DAEMON} -c \${CONFIGFILE} || echo -n "nginx already running"
}
do_stop() {
\${DAEMON}-s stop || echo -n "nginx not running"
}
do_reload() {
\${DAEMON}-s reload || echo -n "nginx can't reload"
}
do_test() {
\${DAEMON}-t || echo -n "nginx can't test"
}
do_status() {
  if [ ! -r \${PIDFILE} ] ; then
          echo "nginx is stopped"
          exit 0
  fi

  PID=`/usr/bin/cat \${PIDFILE}`
  if /usr/bin/ps -p \${PID} | /usr/bin/grep -q \${PID}; then
          echo "nginx (pid \${PID}) is running..."
  else
          echo "nginx dead but pid file exists"
  fi
}
case "\$1" in
status)
echo -n "Show status"
do_status
echo "."
;;
start)
echo -n "Starting \${DESC}: \${NAME}"
do_start
echo "."
;;
stop)
echo -n "Stopping \${DESC}: \${NAME}"
do_stop
echo "."
;;
reload|graceful)
echo -n "Reloading \${DESC} configuration..."
do_reload
echo "."
;;
restart)
echo -n "Restarting \${DESC}: \${NAME}"
do_stop
do_start
echo "."
;;
test)
echo -n "test \${DESC}: \${NAME}"
do_test
echo "."
;;
*)
echo "Usage: \${SCRIPTNAME} {status|test|start|stop|reload|restart}" >&2
exit 3
;;
esac
exit 0

EOF
printLog '添加执行权限并启动nginx'
chmod a+x $nginx_init_bin
$nginx_init_bin start

