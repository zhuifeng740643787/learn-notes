# 设置黑白名单

## 使用/etc/hosts.allow和/etc/hosts.deny来设置ip白名单和黑名单
- 优先级为先检查hosts.deny，再检查hosts.allow，后者设定可覆盖前者限制
- 例如：
    + 限制所有的ssh, 除了218.64.87.0 - 127上来。
    ```
    hosts.deny: 
    in.sshd:ALL 
    hosts.allow: 
    in.sshd:218.64.87.0/255.255.255.128
    ```
    + 封掉218.64.87.0 - 127的telnet 
    ```
    hosts.deny 
    in.sshd:218.64.87.0/255.255.255.128
    ```
    + 限制所有人的TCP连接，除非从218.64.87.0 - 127访问 
    ```
    hosts.deny 
    ALL:ALL 
    hosts.allow 
    ALL:218.64.87.0/255.255.255.128
    ```
    + 限制218.64.87.0 - 127对所有服务的访问 
    ```
    hosts.deny 
    ALL:218.64.87.0/255.255.255.128
    ```

## 使用iptables防火墙
- 拒绝所有IP访问80端口
```
iptables -A INPUT -p tcp -s 0.0.0.0/0 --dport 80 -j DROP    
```

