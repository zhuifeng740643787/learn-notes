# 启动文件
- /etc/init.d/nginx
```
#! /bin/bash
# chkconfig: - 85 15
PATH=/usr/local/nginx
DESC="nginx daemon"
NAME=nginx
DAEMON=$PATH/sbin/$NAME
CONFIGFILE=$PATH/conf/$NAME.conf
PIDFILE=/var/run/$NAME.pid
SCRIPTNAME=/etc/init.d/$NAME
set -e
[ -x "$DAEMON" ] || exit 0
do_start() {
$DAEMON -c $CONFIGFILE || echo -n "nginx already running"
}
do_stop() {
$DAEMON -s stop || echo -n "nginx not running"
}
do_reload() {
$DAEMON -s reload || echo -n "nginx can't reload"
}
do_test() {
$DAEMON -t || echo -n "nginx can't test"
}
do_status() {
  if [ ! -r $PIDFILE ] ; then
          echo "nginx is stopped"
          exit 0
  fi

  PID=`/usr/bin/cat $PIDFILE`
  if /usr/bin/ps -p $PID | /usr/bin/grep -q $PID; then
          echo "nginx (pid $PID) is running..."
  else
          echo "nginx dead but pid file exists"
  fi
}
case "$1" in
status)
echo -n "Show status"
do_status
echo "."
;;
start)
echo -n "Starting $DESC: $NAME"
do_start
echo "."
;;
stop)
echo -n "Stopping $DESC: $NAME"
do_stop
echo "."
;;
reload|graceful)
echo -n "Reloading $DESC configuration..."
do_reload
echo "."
;;
restart)
echo -n "Restarting $DESC: $NAME"
do_stop
do_start
echo "."
;;
test)
echo -n "test $DESC: $NAME"
do_test
echo "."
;;
*)
echo "Usage: $SCRIPTNAME {status|test|start|stop|reload|restart}" >&2
exit 3
;;
esac
exit 0
```