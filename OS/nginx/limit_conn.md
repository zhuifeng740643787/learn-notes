# 并发限制

## 需求
- 秒杀、抢购并发限制、队列缓冲
- 下载带宽限制
- 防止攻击

## nginx连接数限制模块

### limit_conn_zone指令
- 只能在http段
- 语法
    ```
    limit_conn_zone key zone=name:size;
    ```
    key => $binary_remote_addr #二进制的IP地址
name => addr #随便取的一个名字，比如，你可以取成abc
size => 10m #空间大小，这里是10兆
一个二进制的ip地址在32位机器上占用32个字节，在64位机器上占用63个字节，那么10M可以存放多少呢，计算一下，10x1024x1024/32 =         327680，意思就是可以存放326780个ip地址（32位），64位可以存放163840个ip

当共享内存空间被耗尽，服务器将会对后续所有的请求返回 503 (Service Temporarily Unavailable) 错误

### limit_conn指令

