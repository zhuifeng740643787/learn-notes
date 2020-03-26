# nsqlookupd
+ 管理拓扑信息并提供最终一致性的发现服务的守护进程

## 选项: 
+ --broadcast-address 广播地址
+ --config 配置文件地址
+ --tcp-address 监听客户端tcp请求的地址(供nsqd注册)
+ --http-address 监听客户端http请求的地址(供消费者发现)
+ --log-prefix 日志前缀
+ --inactive-producer-timeout 生产者活跃超时时间
+ --tombstone-lifetime 生产者在墓碑中的持续时间
+ --verbose 启用详细日志 
+ --version 打印版本信息

## 启动:
```
mkdir -p /usr/local/nsq/config && \
nsqlookupd \
    --broadcast-address=local-nsqlookup \
    --config=/usr/local/nsq/config/nsqlookupd.conf \
    --tcp-address=0.0.0.0:40000 \
    --http-address=0.0.0.0:40001
```

## 接口
+ GET /lookup 获取主题对应的生产者列表
+ GET /topics 获取主题列表
+ GET /channels 获取主题对应的通道列表
+ GET /nodes 获取nsqd节点列表
+ POST /topic/create 创建主题
+ POST /topic/delete 删除主题
+ POST /channel/create 创建主题对应的通道
+ POST /channel/delete 删除主题对应的通道
+ POST /topic/tombstone 将主题对应的生产者设为墓碑
+ GET /ping 监测端点
+ GET /info 获取版本信息

