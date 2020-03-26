# 配置

## 服务控制
- `/etc/init.d/lsyncd start` 启动服务
- `/etc/init.d/lsyncd stop` 停止服务
- `/etc/init.d/lsyncd restart` 重启服务
- `tail -f /acs/log/lsyncd/lsyncd.log` 监控服务日志

## 增大inotify实例可监听的最大上限数量
```
sysctl fs.inotify.max_user_watches=1000000
```

## /etc/hosts
```
192.168.52.1     host1
192.168.52.2     host2
192.168.52.3     host3
```

## /etc/lsyncd.conf
```
settings {
    pidfile = "/var/run/lsyncd.pid", -- 进程ID
    logfile ="/acs/log/lsyncd/lsyncd.log", -- 日志路径
    statusFile ="/acs/log/lsyncd/lsyncd.status", -- 目录状态
    inotifyMode = "CloseWrite or Modify",  -- 触发模式
    maxProcesses = 4, -- 同步时的最大进程数
    statusInterval = 10, -- 间隔多少秒记录一次监控目录的状态
}

servers = { 'www@host1', 'www@host2', 'www@host3' } -- 服务列表
for _, server in ipairs( servers ) do
    sync {
        default.rsync,
        source    = "/acs/code/project",  --  源文件
        target    = server .. ":/acs/code/project", -- 目标文件
        maxDelays = 5, -- 延迟事件数
        delay = 2, -- 延迟秒数
        -- init = false, -- true: 同步所有文件 false: 同步进程开启后修改过的文件
        delete = "running",
        exclude = { 'tmp/cache/*', '*.log' , '*.tmp', '*.bak' },
        rsync     = {
            binary = "/usr/bin/rsync",
            archive = true, -- 归档模式同步
            compress = true, -- 压缩后再同步
            bwlimit   = 2000, -- 限速同步
            rsh = "/usr/bin/ssh -p 22 -o StrictHostKeyChecking=no", -- 指定ssh配置
            perms = true, -- 保留文件原始属性
        }
    }
end
```

## /etc/init.d/lsyncd
```
#! /bin/bash
PATH=/usr/bin/lsyncd
DESC="lsyncd daemon"
NAME=lsyncd
DAEMON=$PATH
CONFIGFILE=/etc/$NAME.conf
PIDFILE=/var/run/$NAME.pid
SCRIPTNAME=/etc/init.d/$NAME
set -e
[ -x "$DAEMON" ] || exit 0
do_start() {
$DAEMON $CONFIGFILE || echo -n "lsyncd already running"
}
do_stop() {
kill -9 `/usr/bin/cat $PIDFILE` || echo -n "lsyncd not running"
}
do_status() {
  if [ ! -r $PIDFILE ] ; then
          echo "lsyncd is stopped"
          exit 0
  fi

  PID=`/usr/bin/cat $PIDFILE`
  if /usr/bin/ps -p $PID | /usr/bin/grep -q $PID; then
          echo "lsyncd (pid $PID) is running..."
  else
          echo "lsyncd dead but pid file exists"
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
restart)
echo -n "Restarting $DESC: $NAME"
do_stop
do_start
echo "."
;;
*)
echo "Usage: $SCRIPTNAME {status|start|stop|restart}" >&2
exit 3
;;
esac
exit 0
```