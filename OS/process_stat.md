# 进程状态
[参考文档](http://blog.51cto.com/stevenlee87/1210516)

## 状态说明
```
S(state of? the process ) 
O：进程正在处理器运行　 ms这个状态从来木见过， 倒是R常见
S：休眠状态（sleeping） 
R：等待运行（runable）　　　 R Running or runnable (on run queue) 进程处于运行或就绪状态
I：空闲状态（idle） 
Z：僵尸状态（zombie）　　　 
T：跟踪状态（Traced） 
B：进程正在等待更多的内存页 
D:不可中断的深度睡眠，一般由IO引起，同步IO在做读或写操作时，cpu不能做其它事情，只能等待，这时进程处于这种状态，如果程序采用异步IO，这种状态应该就很少见到了
C(cpu usage)：cpu利用率的估算值
```

ps 的手册里说D状态是uninterruptible sleep，Linux进程有两种睡眠状态，一种interruptible sleep，处在这种睡眠状态的进程是可以通过给它发信号来唤醒的，比如发HUP信号给nginx的master进程可以让nginx重新加载配置文件而不需要重新启动nginx进程；另外一种睡眠状态是uninterruptible sleep，处在这种状态的进程不接受外来的任何信号，这也是为什么之前我无法用kill杀掉这些处于D状态的进程，无论是”kill”, “kill -9″还是”kill -15″，因为它们压根儿就不受这些信号的支配。
进程为什么会被置于uninterruptible sleep状态呢？处于uninterruptible sleep状态的进程通常是在等待IO，比如磁盘IO，网络IO，其他外设IO，如果进程正在等待的IO在较长的时间内都没有响应，那么就很会不幸地被 ps看到了，同时也就意味着很有可能有IO出了问题，可能是外设本身出了故障，也可能是比如挂载的远程文件系统已经不可访问了，我这里遇到的问题就是由 down掉的NFS服务器引起的。
正是因为得不到IO的相应，进程才进入了uninterruptible sleep状态，所以要想使进程从uninterruptible sleep状态恢复，就得使进程等待的IO恢复，比如如果是因为从远程挂载的NFS卷不可访问导致进程进入uninterruptible sleep状态的，那么可以通过恢复该NFS卷的连接来使进程的IO请求得到满足，除此之外，要想干掉处在D状态进程就只能重启整个Linux系统了。

有一类垃圾却并非这么容易打扫，那就是我们常见的状态为 D (Uninterruptible sleep) ，以及状态为 Z (Zombie) 的垃圾进程。这些垃圾进程要么是求而不得，像怨妇一般等待资源(D)，要么是僵而不死，像冤魂一样等待超度(Z)，它们在 CPU run_queue 里滞留不去，把 Load Average 弄的老高老高，没看过我前一篇blog的国际友人还以为这儿民怨沸腾又出了什么大事呢。怎么办？开枪！kill -9！看你们走是不走。但这两种垃圾进程偏偏是刀枪不入的，不管换哪种枪法都杀不掉它们。无奈，只好reboot，像剿灭禽流感那样不分青红皂白地一律扑杀！