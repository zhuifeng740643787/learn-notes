# nsqd
+ 一个负责接收、排队、转发消息到客户端的守护进程

## 选项: 
+ --auth-http-address 授权服务地址
+ --broadcast-address nsqlookupd广播地址，用于注册
+ --config 配置地址
+ --data-path 磁盘存储消息的路径
+ --deflate 启用压缩
+ --e2e-processing-latency-percentile value
        message processing time percentiles (as float (0, 1.0]) to track (can be specified multiple times or comma separated '1.0,0.99,0.95', default none)
+ --e2e-processing-latency-window-time duration
        calculate end to end latency quantiles for this duration of time (ie: 60s would only show quantile calculations from the past 60 seconds) (default 10m0s)
+ --http-address http客户端访问的地址
+ --http-client-connect-timeout http客户端连接超时时间
+ --http-client-request-timeout http客户端请求超时时间
+ --https-address https客户端连接超时时间
+ --log-prefix 日志前缀
+ --lookupd-tcp-address nsqlookupdTCP地址
+ --max-body-size 一条命令的字节大小
+ --max-bytes-per-file 每个磁盘文件的最大字节数
+ --max-deflate-level 最大的压缩等级
+ --max-heartbeat-interval 最大心跳检测间隔
+ --max-msg-size 一条消息的最大字节数
+ --max-msg-timeout 每条消息的最大超时时间
+ --max-output-buffer-size int
        maximum client configurable size (in bytes) for a client output buffer (default 65536)
+ --max-output-buffer-timeout duration
        maximum client configurable duration of time between flushing to a client (default 1s)
+ --max-rdy-count 每个客户端最大RDY状态的个数
+ --max-req-timeout 每个消息重新排队的超时时间
+ --mem-queue-size 保存在内存中的消息个数(每个主题/通道)
+ --msg-timeout string
        duration to wait before auto-requeing a message (default "1m0s")
+ --node-id int
        unique part for message IDs, (int) in range [0,1024) (default is hash of hostname) (default 616)
+ --snappy
        enable snappy feature negotiation (client compression) (default true)
+ --statsd-address string
        UDP <addr>:<port> of a statsd daemon for pushing stats
+ --statsd-interval string
        duration between pushing to statsd (default "1m0s")
+ --statsd-mem-stats
        toggle sending memory and GC stats to statsd (default true)
+ --statsd-prefix string
        prefix used for keys sent to statsd (%s for host replacement) (default "nsq.%s")
+ --sync-every int
        number of messages per diskqueue fsync (default 2500)
+ --sync-timeout duration
        duration of time per diskqueue fsync (default 2s)
+ --tcp-address TCP客户端访问的地址
+ --tls-cert string
        path to certificate file
+ --tls-client-auth-policy string
        client certificate auth policy ('require' or 'require-verify')
+ --tls-key string
        path to key file
+ --tls-min-version value
        minimum SSL/TLS version acceptable ('ssl3.0', 'tls1.0', 'tls1.1', or 'tls1.2') (default 769)
+ --tls-required
        require TLS for client connections (true, false, tcp-https)
+ --tls-root-ca-file string
        path to certificate authority file
+ --verbose 启用详细日志 
+ --version 打印版本信息
+ --worker-id 废弃, 不要使用，用--node-id

## 启动:
```
mkdir -p /usr/local/nsq/config && \
mkdir -p /usr/local/nsq/data && \
nsqd \
    --broadcast-address=local-nsqlookup \
    --config=/usr/local/nsq/config/nsqld.conf \
    --data-path=/usr/local/nsq/data/nsqd \
    --lookupd-tcp-address=0.0.0.0:40000 \
    --tcp-address=0.0.0.0:41000 \
    --http-address=0.0.0.0:41001 
```

## 接口
+ POST /pub 发布消息
+ POST /mpub 批量发布消息, 多个消息以`\n`分割
+ POST /topic/create 创建主题
+ POST /topic/delete 删除主题
+ POST /channel/create 创建通道
+ POST /channel/delete 删除通道
+ POST /topic/empty 清空主题
+ POST /channel/empty 清空通道
+ POST /topic/pause 暂停主题中的消息流向通道,消息将在主题中排队
+ POST /topic/unpause 恢复主题中的消息流向通道
+ POST /channel/pause 暂停通道中的消息流向消费者,消息将在通道中排队
+ POST /channel/unpause 恢复通道中的消息流向消费者
+ GET /stats 获取内部统计信息
+ GET /ping 监测终端，200 OK, 500 不健康
+ GET /info 版本信息
+ GET /debug/pprof 调试终端
+ GET /debug/pprof/profile 获取CPU信息
+ GET /debug/pprof/goroutine 获取所有运行的协程的堆栈信息
+ GET /debug/pprof/heap 获取内存信息
+ GET /debug/pprof/block 获取协程阻塞信息
+ GET /debug/pprof/threadcreate 获取导致创建操作系统线程的goroutine堆栈跟踪
+ GET /config/nsqlookupd_tcp_addresses 获取nsqlookup tcp 地址列表
+ PUT /config/nsqlookupd_tcp_addresses 更新nsqlookup tcp 地址列表
