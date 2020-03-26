# lsyncd 文件实时同步
[参考文献](http://seanlook.com/2015/05/06/lsyncd-synchronize-realtime)
[官网手册](https://axkibe.github.io/lsyncd/manual/config/layer4/)

Lysncd 实际上是lua语言封装了 inotify 和 rsync 工具，采用了 Linux 内核（2.6.13 及以后）里的 inotify 触发机制，然后通过rsync去差异同步，达到实时的效果。我认为它最令人称道的特性是，完美解决了 inotify + rsync海量文件同步带来的文件频繁发送文件列表的问题 —— 通过时间延迟或累计触发事件次数实现。另外，它的配置方式很简单，lua本身就是一种配置语言，可读性非常强。lsyncd也有多种工作模式可以选择，本地目录cp，本地目录rsync，远程目录rsyncssh。

## 安装
```
# yum install lua lua-devel
# rpm -ivh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
# yum install lsyncd
```

## lsyncd.conf配置选项说明
- settings
```
里面是全局设置，--开头表示注释，下面是几个常用选项说明：

logfile 定义日志文件
stausFile 定义状态文件
nodaemon=true 表示不启用守护模式，默认
statusInterval 将lsyncd的状态写入上面的statusFile的间隔，默认10秒
inotifyMode 指定inotify监控的事件，默认是CloseWrite，还可以是Modify或CloseWrite or Modify
maxProcesses 同步进程的最大个数。假如同时有20个文件需要同步，而maxProcesses = 8，则最大能看到有8个rysnc进程
maxDelays 累计到多少所监控的事件激活一次同步，即使后面的delay延迟时间还未到
```
- sync
```
里面是定义同步参数，可以继续使用maxDelays来重写settings的全局变量。一般第一个参数指定lsyncd以什么模式运行：rsync、rsyncssh、direct三种模式：

default.rsync ：本地目录间同步，使用rsync，也可以达到使用ssh形式的远程rsync效果，或daemon方式连接远程rsyncd进程；
default.direct ：本地目录间同步，使用cp、rm等命令完成差异文件备份；
default.rsyncssh ：同步到远程主机目录，rsync的ssh模式，需要使用key来认证

source 同步的源目录，使用绝对路径。

target 定义目的地址.对应不同的模式有几种写法：
/tmp/dest ：本地目录同步，可用于direct和rsync模式
172.29.88.223:/tmp/dest ：同步到远程服务器目录，可用于rsync和rsyncssh模式，拼接的命令类似于/usr/bin/rsync -ltsd --delete --include-from=- --exclude=* SOURCE TARGET，剩下的就是rsync的内容了，比如指定username，免密码同步
172.29.88.223::module ：同步到远程服务器目录，用于rsync模式
三种模式的示例会在后面给出。

init 这是一个优化选项，当init = false，只同步进程启动以后发生改动事件的文件，原有的目录即使有差异也不会同步。默认是true

delay 累计时间，等待rsync同步延时时间，默认15秒（最大累计到1000个不可合并的事件）。也就是15s内监控目录下发生的改动，会累积到一次rsync同步，避免过于频繁的同步。（可合并的意思是，15s内两次修改了同一文件，最后只同步最新的文件）

excludeFrom 排除选项，后面指定排除的列表文件，如excludeFrom = "/etc/lsyncd.exclude"，如果是简单的排除，可以使用exclude = LIST。
这里的排除规则写法与原生rsync有点不同，更为简单：
监控路径里的任何部分匹配到一个文本，都会被排除，例如/bin/foo/bar可以匹配规则foo
如果规则以斜线/开头，则从头开始要匹配全部
如果规则以/结尾，则要匹配监控路径的末尾
?匹配任何字符，但不包括/
*匹配0或多个字符，但不包括/
**匹配0或多个字符，可以是/
delete 为了保持target与souce完全同步，Lsyncd默认会delete = true来允许同步删除。它除了false，还有startup、running值，请参考 Lsyncd 2.1.x ‖ Layer 4 Config ‖ Default Behavior。
rsync
（提示一下，delete和exclude本来都是rsync的选项，上面是配置在sync中的，我想这样做的原因是为了减少rsync的开销）

bwlimit 限速，单位kb/s，与rsync相同（这么重要的选项在文档里竟然没有标出）
compress 压缩传输默认为true。在带宽与cpu负载之间权衡，本地目录同步可以考虑把它设为false
perms 默认保留文件权限。
其它rsync的选项
其它还有rsyncssh模式独有的配置项，如host、targetdir、rsync_path、password_file，见后文示例。rsyncOps={"-avz","--delete"}这样的写法在2.1.*版本已经不支持。

lsyncd.conf可以有多个sync，各自的source，各自的target，各自的模式，互不影响。
```

## 启动lsyncd
```
lsyncd -log Exec /etc/lsyncd.conf
```

## 示例
```
settings {
    logfile ="/usr/local/lsyncd-2.1.5/var/lsyncd.log",
    statusFile ="/usr/local/lsyncd-2.1.5/var/lsyncd.status",
    inotifyMode = "CloseWrite",
    maxProcesses = 8,
    }


-- I. 本地目录同步，direct：cp/rm/mv。 适用：500+万文件，变动不大
sync {
    default.direct,
    source    = "/tmp/src",
    target    = "/tmp/dest",
    delay = 1
    maxProcesses = 1
    }

-- II. 本地目录同步，rsync模式：rsync
sync {
    default.rsync,
    source    = "/tmp/src",
    target    = "/tmp/dest1",
    excludeFrom = "/etc/rsyncd.d/rsync_exclude.lst",
    rsync     = {
        binary = "/usr/bin/rsync",
        archive = true,
        compress = true,
        bwlimit   = 2000
        } 
    }

-- III. 远程目录同步，rsync模式 + rsyncd daemon
sync {
    default.rsync,
    source    = "/tmp/src",
    target    = "syncuser@172.29.88.223::module1",
    delete="running",
    exclude = { ".*", ".tmp" },
    delay = 30,
    init = false,
    rsync     = {
        binary = "/usr/bin/rsync",
        archive = true,
        compress = true,
        verbose   = true,
        password_file = "/etc/rsyncd.d/rsync.pwd",
        _extra    = {"--bwlimit=200"}
        }
    }

-- IV. 远程目录同步，rsync模式 + ssh shell
sync {
    default.rsync,
    source    = "/tmp/src",
    target    = "172.29.88.223:/tmp/dest",
    -- target    = "root@172.29.88.223:/remote/dest",
    -- 上面target，注意如果是普通用户，必须拥有写权限
    maxDelays = 5,
    delay = 30,
    -- init = true,
    rsync     = {
        binary = "/usr/bin/rsync",
        archive = true,
        compress = true,
        bwlimit   = 2000
        -- rsh = "/usr/bin/ssh -p 22 -o StrictHostKeyChecking=no"
        -- 如果要指定其它端口，请用上面的rsh
        }
    }

-- V. 远程目录同步，rsync模式 + rsyncssh，效果与上面相同
sync {
    default.rsyncssh,
    source    = "/tmp/src2",
    host      = "172.29.88.223",
    targetdir = "/remote/dir",
    excludeFrom = "/etc/rsyncd.d/rsync_exclude.lst",
    -- maxDelays = 5,
    delay = 0,
    -- init = false,
    rsync    = {
        binary = "/usr/bin/rsync",
        archive = true,
        compress = true,
        verbose   = true,
        _extra = {"--bwlimit=2000"},
        },
    ssh      = {
        port  =  1234
        }
    }
```