# php-fpm性能调优
[参考文档](https://www.kancloud.cn/digest/php-src/136260)
- PHP-FPM是一个PHPFastCGI管理器，是只用于PHP的。

## 关于信号处理
- SIGINT, SIGTERM 立刻终止
- SIGQUIT 平滑终止
- SIGUSR1 重新打开日志文件
- SIGUSR2 平滑重载所有worker进程并重新载入配置和二进制模

## 参数调优

### 进程数
```
首先，我们关注一个前提设置： pm = static/dynamic,标识fpm子进程的产生模式
static(静态) ：表示在fpm运行时直接fork出pm.max_chindren个worker进程
dynamic(动态)：表示运行时fork出start_servers个进程，随着负载的情况，动态的调整，最多不超过max_children个进程。
一般推荐用static，优点是不用动态的判断负载情况，提升性能，缺点是多占用些系统内存资源。
static:worker进程 pm.max_children = 300   这个值原则上是越大越好
dynamic:worker进程    pm.start_servers = 20   
dynamic:空闲状态    pm.min_spare_servers = 5    最小php-fpm进程数量
dynamic:空闲状态    pm.max_spare_servers = 35   最大php-fpm进程数量
```
- max_children
    + 这个值原则上是越大越好，php-cgi的进程多了就会处理的很快，排队的请求就会很少。
    + 设置”max_children”也需要根据服务器的性能进行设定
    + 一般来说一台服务器正常情况下每一个php-cgi所耗费的内存在20M左右
    + 假设“max_children”设置成100个，20M*100=2000M
    + 也就是说在峰值的时候所有PHP-CGI所耗内存在2000M以内。
    + 假设“max_children”设置的较小，比如5-10个，那么php-cgi就会“很累”，处理速度也很慢，等待的时间也较长。
    + 如果长时间没有得到处理的请求就会出现504 Gateway Time-out这个错误，而正在处理的很累的那几个php-cgi如果遇到了问题就会出现502 Bad gateway这个错误。
- start_servers
    + pm.start_servers的默认值为2。并且php-fpm中给的计算方式也为：
{（cpu空闲时等待连接的php的最小子进程数） + （cpu空闲时等待连接的php的最大子进程数 - cpu空闲时等待连接的php的最小子进程数）/ 2}；
    + 用配置表示就是：min_spare_servers + (max_spare_servers - min_spare_servers) / 2；
    + 一般而言，设置成10-20之间的数据足够满足需求了。

### 最大请求数max_requests
```
最大处理请求数是指一个php-fpm的worker进程在处理多少个请求后就终止掉，master进程会重新respawn一个新的。
这个配置的主要目的是避免php解释器或程序引用的第三方库造成的内存泄露。
pm.max_requests = 10240
```
- 当一个 PHP-CGI 进程处理的请求数累积到 max_requests 个后，自动重启该进程。
- 502，是后端 PHP-FPM 不可用造成的，间歇性的502一般认为是由于 PHP-FPM 进程重启造成的.
- 但是为什么要重启进程呢？ 
- 如果不定期重启 PHP-CGI 进程，势必造成内存使用量不断增长（比如第三方库有问题等）。因此 PHP-FPM 作为 PHP-CGI 的管理器，提供了这么一项监控功能，对请求达到指定次数的 PHP-CGI 进程进行重启，保证内存使用量不增长。
- 正是因为这个机制，在高并发中，经常导致 502 错误
- 目前我们解决方案是把这个值尽量设置大些，减少 PHP-CGI 重新 SPAWN 的次数，同时也能提高总体性能。PS：刚开始我们是500导致内存飙高，现在改成5120，当然可以再大一些，10240等，这个主要看测试结果，如果没有内存泄漏等问题，可以再大一些。

### 最长执行时间request_terminate_timeout
```
设置单个请求的超时中止时间. 该选项可能会对php.ini设置中的’max_execution_time’因为某些特殊原因没有中止运行的脚本有用. 设置为 ‘0’ 表示 ‘Off’.当经常出现502错误时可以尝试更改此选项。
```
- 这两项都是用来配置一个PHP脚本的最大执行时间的。当超过这个时间时，PHP-FPM不只会终止脚本的执行，还会终止执行脚本的Worker进程。
- Nginx会发现与自己通信的连接断掉了，就会返回给客户端502错误。

## 问题排查及跟踪

### 内存|CPU排查方法
- top命令
```
参数说明：
d： 指定每两次屏幕信息刷新之间的时间间隔。当然用户可以使用s交互命令来改变之。
p： 通过指定监控进程ID来监控某个进程的状态。
q：该选项将使top没有任何延迟的进行刷新。如果调用程序有超级用户权限，那么top将以尽可能高的优先级运行。
S： 指定累计模式
s ： 使top命令在安全模式中运行。这将去除交互命令所带来的潜在危险。
i： 使top不显示任何闲置或者僵死进程。、
m：切换显示内存信息。
t：切换显示进程和CPU状态信息。
c：切换显示命令名称和完整命令行。
M： 根据驻留内存大小进行排序。
P：根据CPU使用百分比大小进行排序。
T：根据时间/累计时间进行排序。
```
- sar
```
执行sar -P ALL 1 100。-P ALL表示监控所有核心，1表示每1秒采集，100表示采集100次。
```

### 开启慢日志
- 配置输出php-fpm慢日志，阀值为2秒
```
request_slowlog_timeout = 2
slowlog = log/$pool.log.slow
```
- 利用sort/uniq命令分析汇总php-fpm慢日志：
```
grep -v “^$” www.log.slow.tmp | cut -d ” ” -f 3,2 | sort | uniq -c | sort -k1,1nr | head -n 50
参数解释：
sort: 对单词进行排序
uniq -c: 显示唯一的行，并在每行行首加上本行在文件中出现的次数
sort -k1,1nr: 按照第一个字段，数值排序，且为逆序
head -10: 取前10行数据
```

### 用strace跟踪进程
```
利用nohup将strace转为后台执行，直到attach上的php-fpm进程死掉为止：
nohup strace -T -p 13167 > 13167-strace.log &
参数说明:
-c 统计每一系统调用的所执行的时间,次数和出错的次数等.
-d 输出strace关于标准错误的调试信息.
-f 跟踪由fork调用所产生的子进程.
-o filename,则所有进程的跟踪结果输出到相应的filename
-F 尝试跟踪vfork调用.在-f时,vfork不被跟踪.
-h 输出简要的帮助信息.
-i 输出系统调用的入口指针.
-q 禁止输出关于脱离的消息.
-r 打印出相对时间关于,,每一个系统调用.
-t 在输出中的每一行前加上时间信息.
-tt 在输出中的每一行前加上时间信息,微秒级.
-ttt 微秒级输出,以秒了表示时间.
-T 显示每一调用所耗的时间.
-v 输出所有的系统调用.一些调用关于环境变量,状态,输入输出等调用由于使用频繁,默认不输出.
-V 输出strace的版本信息.
-x 以十六进制形式输出非标准字符串
-xx 所有字符串以十六进制形式输出.
-a column
设置返回值的输出位置.默认为40.
-e execve 只记录 execve 这类系统调用
-p 主进程号
也可以用利用-c参数让strace帮助汇总
strace -cp pid
```


## PHP-fpm配置文件注释
```
pid = run/php-fpm.pid
#pid设置，默认在安装目录中的var/run/php-fpm.pid，建议开启

error_log = log/php-fpm.log
#错误日志，默认在安装目录中的var/log/php-fpm.log

log_level = notice
#错误级别. 可用级别为: alert（必须立即处理）, error（错误情况）, warning（警告情况）, notice（一般重要信息）, debug（调试信息）. 默认: notice.

emergency_restart_threshold = 60
emergency_restart_interval = 60s
#表示在emergency_restart_interval所设值内出现SIGSEGV或者SIGBUS错误的php-cgi进程数如果超过 emergency_restart_threshold个，php-fpm就会优雅重启。这两个选项一般保持默认值。

process_control_timeout = 0
#设置子进程接受主进程复用信号的超时时间. 可用单位: s(秒), m(分), h(小时), 或者 d(天) 默认单位: s(秒). 默认值: 0.

daemonize = yes
#后台执行fpm,默认值为yes，如果为了调试可以改为no。在FPM中，可以使用不同的设置来运行多个进程池。 这些设置可以针对每个进程池单独设置。

listen = 127.0.0.1:9000
#fpm监听端口，即nginx中php处理的地址，一般默认值即可。可用格式为: 'ip:port', 'port', '/path/to/unix/socket'. 每个进程池都需要设置.

listen.backlog = -1
#backlog数，-1表示无限制，由操作系统决定，此行注释掉就行。backlog含义参考：http://www.3gyou.cc/?p=41

listen.allowed_clients = 127.0.0.1
#允许访问FastCGI进程的IP，设置any为不限制IP，如果要设置其他主机的nginx也能访问这台FPM进程，listen处要设置成本地可被访问的IP。默认值是any。每个地址是用逗号分隔. 如果没有设置或者为空，则允许任何服务器请求连接

listen.owner = www
listen.group = www
listen.mode = 0666
#unix socket设置选项，如果使用tcp方式访问，这里注释即可。

user = www
group = www
#启动进程的帐户和组

pm = dynamic #对于专用服务器，pm可以设置为static。
#如何控制子进程，选项有static和dynamic。如果选择static，则由pm.max_children指定固定的子进程数。如果选择dynamic，则由下开参数决定：
pm.max_children #，子进程最大数
pm.start_servers #，启动时的进程数
pm.min_spare_servers #，保证空闲进程数最小值，如果空闲进程小于此值，则创建新的子进程
pm.max_spare_servers #，保证空闲进程数最大值，如果空闲进程大于此值，此进行清理

pm.max_requests = 1000
#设置每个子进程重生之前服务的请求数. 对于可能存在内存泄漏的第三方模块来说是非常有用的. 如果设置为 '0' 则一直接受请求. 等同于 PHP_FCGI_MAX_REQUESTS 环境变量. 默认值: 0.

pm.status_path = /status
#FPM状态页面的网址. 如果没有设置, 则无法访问状态页面. 默认值: none. munin监控会使用到

ping.path = /ping
#FPM监控页面的ping网址. 如果没有设置, 则无法访问ping页面. 该页面用于外部检测FPM是否存活并且可以响应请求. 请注意必须以斜线开头 (/)。

ping.response = pong
#用于定义ping请求的返回相应. 返回为 HTTP 200 的 text/plain 格式文本. 默认值: pong.

request_terminate_timeout = 0
#设置单个请求的超时中止时间. 该选项可能会对php.ini设置中的'max_execution_time'因为某些特殊原因没有中止运行的脚本有用. 设置为 '0' 表示 'Off'.当经常出现502错误时可以尝试更改此选项。

request_slowlog_timeout = 10s
#当一个请求该设置的超时时间后，就会将对应的PHP调用堆栈信息完整写入到慢日志中. 设置为 '0' 表示 'Off'

slowlog = log/$pool.log.slow
#慢请求的记录日志,配合request_slowlog_timeout使用

rlimit_files = 1024
#设置文件打开描述符的rlimit限制. 默认值: 系统定义值默认可打开句柄是1024，可使用 ulimit -n查看，ulimit -n 2048修改。

rlimit_core = 0
#设置核心rlimit最大限制值. 可用值: 'unlimited' 、0或者正整数. 默认值: 系统定义值.

chroot =
#启动时的Chroot目录. 所定义的目录需要是绝对路径. 如果没有设置, 则chroot不被使用.

chdir =
#设置启动目录，启动时会自动Chdir到该目录. 所定义的目录需要是绝对路径. 默认值: 当前目录，或者/目录（chroot时）

catch_workers_output = yes
#重定向运行过程中的stdout和stderr到主要的错误日志文件中. 如果没有设置, stdout 和 stderr 将会根据FastCGI的规则被重定向到 /dev/null . 默认值: 空.
```

## 总结
- 502
```
max_children
request_terminate_timeout、max_execution_time
数据库
网关服务是否启动如php-fpm
```
- 504
```
错误主要查看nginx.conf关于网关如fastcgi的配置
request_terminate_timeout设置0或者过长问题(502)
如果设置为0或者过长的时间，可能会引起file_get_contents的资源问题。
如果file_get_contents请求的远程资源如果反应过慢，file_get_contents就会一直卡在那里不会超时
我们知道php.ini 里面max_execution_time 可以设置 PHP 脚本的最大执行时间，
但是，在 php-cgi(php-fpm) 中，该参数不会起效。真正能够控制 PHP 脚本最大执行时间的是 php-fpm.conf 配置文件中的request_terminate_timeout参数。
修改该参数，设置 PHP 脚本最大执行时间是必要的，但是，治标不治本。例如改成 30s，如果发生 file_get_contents() 获取网页内容较慢的情况，这就意味着 150 个 php-cgi 进程，每秒钟只能处理 5 个请求，WebServer 同样很难避免”502 Bad Gateway”。
解决办法是request_terminate_timeout设置为10s或者一个合理的值，或者给file_get_contents加一个超时参数。
max_requests参数配置不当，可能会引起间歇性502错误
php-fpm的慢日志，debug及异常排查神
```
