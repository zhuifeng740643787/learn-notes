# 网络状态
[参考文档](http://mntms.iteye.com/blog/2231501)

## TCP
```
TCP状态转移要点
    TCP协议规定，对于已经建立的连接，网络双方要进行四次握手才能成功断开连接，如果缺少了其中某个步骤，将会使连接处于假死状态，连接本身占用的资源不会被释放。网络服务器程序要同时管理大量连接，所以很有必要保证无用连接完全断开，否则大量僵死的连接会浪费许多服务器资源。在众多TCP状态中，最值得注意的状态有两个：CLOSE_WAIT和TIME_WAIT。  
 
1、LISTENING状态
　　FTP服务启动后首先处于侦听（LISTENING）状态。

2、ESTABLISHED状态
　　ESTABLISHED的意思是建立连接。表示两台机器正在通信。

3、CLOSE_WAIT

    对方主动关闭连接或者网络异常导致连接中断，这时我方的状态会变成CLOSE_WAIT 此时我方要调用close()来使得连接正确关闭

4、TIME_WAIT

    我方主动调用close()断开连接，收到对方确认后状态变为TIME_WAIT。TCP协议规定TIME_WAIT状态会一直持续2MSL(即两倍的分段最大生存期)，以此来确保旧的连接状态不会对新连接产生影响。处于TIME_WAIT状态的连接占用的资源不会被内核释放，所以作为服务器，在可能的情况下，尽量不要主动断开连接，以减少TIME_WAIT状态造成的资源浪费。

    目前有一种避免TIME_WAIT资源浪费的方法，就是关闭socket的LINGER选项。但这种做法是TCP协议不推荐使用的，在某些情况下这个操作可能会带来错误。
```

## socket的状态
```
CLOSED  没有使用这个套接字[netstat 无法显示closed状态]
LISTEN  套接字正在监听连接[调用listen后]
SYN_SENT    套接字正在试图主动建立连接[发送SYN后还没有收到ACK]
SYN_RECEIVED    正在处于连接的初始同步状态[收到对方的SYN，但还没收到自己发过去的SYN的ACK]
ESTABLISHED 连接已建立
CLOSE_WAIT  远程套接字已经关闭：正在等待关闭这个套接字[被动关闭的一方收到FIN]
FIN_WAIT_1  套接字已关闭，正在关闭连接[发送FIN，没有收到ACK也没有收到FIN]
CLOSING 套接字已关闭，远程套接字正在关闭，暂时挂起关闭确认[在FIN_WAIT_1状态下收到被动方的FIN]
LAST_ACK    远程套接字已关闭，正在等待本地套接字的关闭确认[被动方在CLOSE_WAIT状态下发送FIN]
FIN_WAIT_2  套接字已关闭，正在等待远程套接字关闭[在FIN_WAIT_1状态下收到发过去FIN对应的ACK]
TIME_WAIT   这个套接字已经关闭，正在等待远程套接字的关闭传送[FIN、ACK、FIN、ACK都完毕，这是主动方的最后一个状态，在过了2MSL时间后变为CLOSED状态]
```

## 状态汇总
```
netstat -n | awk '/^tcp/ {++S[$NF]} END {for(a in S) print a,S[a]}'
```