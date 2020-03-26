# nsqadmin
+ 一套Web用户界面，可实时查看集群的统计数据和执行各种各样的管理任务

## 选项
+ --allow-config-from-cidr string
      A CIDR from which to allow HTTP requests to the /config endpoint (default "127.0.0.1/8")
+ --config 配置文件路径
+ --graphite-url string
      graphite HTTP address
+ --http-address 访问地址
+ --http-client-connect-timeout 客户端连接超时时间
+ --http-client-request-timeout 客户端请求超时时间
+ --http-client-tls-cert string
      path to certificate file for the HTTP client
+ --http-client-tls-insecure-skip-verify
      configure the HTTP client to skip verification of TLS certificates
+ --http-client-tls-key string
      path to key file for the HTTP client
+ --http-client-tls-root-ca-file string
      path to CA file for the HTTP client
+ --log-prefix 日志前缀
+ --lookupd-http-address nsqlookupd http地址
+ --notification-http-endpoint string
      HTTP endpoint (fully qualified) to which POST notifications of admin actions will be sent
+ --nsqd-http-address nsqd http地址
+ --proxy-graphite
      proxy HTTP requests to graphite
+ --statsd-counter-format string
      The counter stats key formatting applied by the implementation of statsd. If no formatting is desired, set this to an empty string. (default "stats.counters.%s.count")
+ --statsd-gauge-format string
      The gauge stats key formatting applied by the implementation of statsd. If no formatting is desired, set this to an empty string. (default "stats.gauges.%s")
+ --statsd-interval duration
      time interval nsqd is configured to push to statsd (must match nsqd) (default 1m0s)
+ --statsd-prefix string
      prefix used for keys sent to statsd (%s for host replacement, must match nsqd) (default "nsq.%s")
+ --version 打印版本信息

## 启动
```
mkdir -p /usr/local/nsq/config && \
nsqadmin \
    --config=/usr/local/nsq/config/nsqadmin.conf \
    --http-address=0.0.0.0:42001 \
    --lookupd-http-address=0.0.0.0:40001
```

## 指标
+ 消息队列：消息队列的锚链接
    - Depth：内存+磁盘上的当前消息总数（即，待发送的消息的“积压”）。
    - In-Flight：当前已发送但尚未完成（FIN），重新排队（REQ）或超时的消息数。
    - Deferred：当前重新排队和显式推迟但尚无法传递的邮件数。
+ 统计：锚链接：统计
    - Requeued：由于超时或显式重新排队而导致消息被添加回队列的总次数。
    - Timed Out：在配置的超时之前未收到来自客户端的响应之后，邮件重新排队的总时间。
    - Messages：自节点启动以来收到的新消息总数。
    - Rate：过去两个统计间隔内的新消息的每秒速率（仅在启用石墨集成时可用）。
    - Connections：当前已连接的客户端数。
+ 客户端连接：锚链接：客户端连接
    - Client Host：客户端ID（主机名）并悬停连接远程地址。
    - Protocol：NSQ协议版本和客户端用户代理。
    - Attributes：TLS和AUTH连接状态。
    - NSQd Host：此客户端连接到的nsqd节点的地址。
    - In-flight：当前已发送到此客户端的等待响应的邮件数。
    - Ready Count：此连接上正在运行的最大邮件数。这由客户端的max_in_flight设置控制。
    - Finished：此客户端已完成的消息总数（FIN）。
    - Requeued：此客户端已重新排队的邮件总数（REQ）。
    - Messages：传递给此客户端的邮件总数。
